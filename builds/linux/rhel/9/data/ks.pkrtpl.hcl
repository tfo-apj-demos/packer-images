#version=RHEL9
# RHEL9 UEFI/GPT Kickstart for vSphere with vTPM

###############################################################################
# Basic setup
###############################################################################
cdrom
text
eula --agreed

lang ${vm_guest_os_language}
keyboard ${vm_guest_os_keyboard}
timezone ${vm_guest_os_timezone}

network --bootproto=dhcp --device=ens192 --onboot=yes

rootpw --lock
user --name=${build_username} --iscrypted --password="${build_password_encrypted}" --groups=wheel

firewall --enabled --ssh
authselect select sssd
selinux --enforcing
skipx

###############################################################################
# Disk partitioning (UEFI/GPT)
###############################################################################
zerombr
clearpart --all --initlabel --drives=sda

# EFI System Partition (FAT32, ~600 MiB)
part /boot/efi --fstype=vfat --size=600 --label=EFI-SYSTEM --fsoptions="umask=0077,shortname=winnt"

# /boot partition (ext4, 1 GiB)
part /boot     --fstype=ext4 --size=1024 --label=BOOT

# LVM for the rest
part pv.01     --size=1 --grow
volgroup sysvg --pesize=4096 pv.01

logvol swap   --fstype=swap --vgname=sysvg --size=1024   --name=lv_swap   --label=SWAPFS
logvol /      --fstype=xfs  --vgname=sysvg --size=12288  --name=lv_root   --label=ROOTFS
logvol /home  --fstype=xfs  --vgname=sysvg --size=4096   --name=lv_home   --label=HOMEFS   --fsoptions="nodev,nosuid"
logvol /opt   --fstype=xfs  --vgname=sysvg --size=2048   --name=lv_opt    --label=OPTFS    --fsoptions="nodev"
logvol /tmp   --fstype=xfs  --vgname=sysvg --size=4096   --name=lv_tmp    --label=TMPFS    --fsoptions="nodev,noexec,nosuid"
logvol /var   --fstype=xfs  --vgname=sysvg --size=4096   --name=lv_var    --label=VARFS    --fsoptions="nodev"
logvol /var/log       --fstype=xfs --vgname=sysvg --size=4096   --name=lv_log    --label=LOGFS    --fsoptions="nodev,noexec,nosuid"
logvol /var/log/audit --fstype=xfs --vgname=sysvg --size=4096   --name=lv_audit  --label=AUDITFS --fsoptions="nodev,noexec,nosuid"

###############################################################################
# Bootloader (UEFI / GRUB2)
###############################################################################
# --location=mbr here triggers the installer to register UEFI entry
# and copy bootloader into /boot/efi automatically.
#bootloader --timeout=5 --append="crashkernel=auto" --location=mbr --driveorder=sda
bootloader --timeout=5 --append="crashkernel=auto" --driveorder=sda

services --enabled=NetworkManager,sshd

%packages --ignoremissing --excludedocs
@core
efibootmgr
grub2-efi-x64 
shim-x64
-iwl*firmware
perl
open-vm-tools
%end

###############################################################################
# Post-install: EPEL, sudo, NM tweaks, then fix UEFI entries
###############################################################################
%post --log=/var/log/kickstart_post.log 
set -x
# EPEL
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache

# Passwordless sudo
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${build_username}
sed -i 's/^.*requiretty/# Defaults requiretty/' /etc/sudoers

# NM autoconnect priority
for conn in /etc/NetworkManager/system-connections/*.connection; do
  grep -q '^\[connection\]' "$conn" && \
    echo 'autoconnect-priority=-999' >> "$conn"
done
systemctl restart NetworkManager

# ---- UEFI NVRAM cleanup ----
# Mount the EFI variable filesystem
mkdir -p /sys/firmware/efi/efivars
mount -t efivarfs efivarfs /sys/firmware/efi/efivars

# detect the RHEL entry (Boot0005)
DISK_ENTRY=$(efibootmgr -v   | awk -F '*' '/[Rr]ed[[:space:]]?Hat/ { sub(/^Boot/, "", $1); print $1; exit }')

# prune everything except Boot0005
for id in $(efibootmgr | sed -n 's/Boot\([0-9A-F]\{4\}\).*/\1/p'); do
  [ "$id" != "$DISK_ENTRY" ] && efibootmgr -b $id -B
done

# leave only Boot0005 as the boot order
efibootmgr -o $DISK_ENTRY
efibootmgr -n $DISK_ENTRY 

sync
sleep 5
sync

set +x 
%end

# reboot and eject installer media
eject -m 
shutdown -r now