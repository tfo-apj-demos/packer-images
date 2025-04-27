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
bootloader --timeout=0 --append="crashkernel=auto" --driveorder=sda

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
# EPEL installation and cache update
echo "Installing EPEL repository"
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache
echo "EPEL repository installed and cache updated"

# Passwordless sudo setup for build user
echo "Setting up passwordless sudo for user ${build_username}"
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${build_username}
sed -i 's/^.*requiretty/# Defaults requiretty/' /etc/sudoers
echo "Passwordless sudo set up for ${build_username}"

# NetworkManager autoconnect priority tweak
echo "Configuring NetworkManager autoconnect priority"
for conn in /etc/NetworkManager/system-connections/*.connection; do
  grep -q '^\[connection\]' "$conn" && \
    echo 'autoconnect-priority=-999' >> "$conn"
done
systemctl restart NetworkManager
echo "NetworkManager autoconnect priority configured"

# Debug: Show current EFI boot entries before making changes
echo "Checking current EFI boot entries:"
efibootmgr -v

# ---- UEFI NVRAM cleanup ----
# find boot numbers
DISK_ENTRY=$(efibootmgr -v | awk -F '*' '/[Rr]ed[[:space:]]?Hat/ { sub(/^Boot/,"",$1); print $1; exit }')
echo "Found Red Hat boot entry: $DISK_ENTRY"

# find EFI Virtual Disk entry
VD_ENTRY=$(efibootmgr -v | awk -F '*' '/EFI Virtual disk/ { sub(/^Boot/,"",$1); print $1; exit }')
echo "Found EFI Virtual Disk entry: $VD_ENTRY"

# remove stray "EFI Virtual disk" entry if it exists
if [ -n "$VD_ENTRY" ]; then
  echo "Removing EFI Virtual Disk entry: $VD_ENTRY"
  efibootmgr -b $VD_ENTRY -B
fi

# set only your Red Hat entry first
if [ -n "$DISK_ENTRY" ]; then
  echo "Setting boot order to Red Hat entry: $DISK_ENTRY"
  efibootmgr -o $DISK_ENTRY
else
  echo "Red Hat boot entry not found"
fi

# ---- Clean up other boot entries ----
echo "Cleaning up all other boot entries except Red Hat"
for id in $(efibootmgr -v | grep -o 'Boot[0-9A-F]\{4\}' | sed 's/Boot//'); do
  if [ "$id" != "$DISK_ENTRY" ]; then
    echo "Removing boot entry: $id"
    efibootmgr -b $id -B
  fi
done

# Verify changes: Show current boot order after cleanup
echo "Final boot order after cleanup:"
efibootmgr -v

# ---- Install GRUB2 for UEFI ----
echo "Installing GRUB2 for UEFI"
dnf install -y grub2-efi-x64 grub2-tools

# Create the necessary directories if missing
mkdir -p /boot/efi/EFI/redhat

# Rebuild the GRUB2 configuration
echo "Rebuilding GRUB configuration"
grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg

# Install GRUB2 to EFI
echo "Installing GRUB to EFI"
grub2-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=redhat

# Final cleanup and verification of boot order
echo "Final verification of boot order:"
efibootmgr -v

echo "Post-install tasks completed."
%end

# reboot and eject installer media
reboot --eject