#version=RHEL9
# RHEL 9 UEFI/GPT Kickstart for vSphere with vTPM

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
user --name=${build_username} --iscrypted --password=${build_password_encrypted} --groups=wheel

firewall --enabled --ssh
authselect select sssd
selinux --enforcing

skipx

###############################################################################
# Disk partitioning (UEFI/GPT)
###############################################################################

# Wipe any existing partition tables, use GPT
zerombr
clearpart --all --initlabel --drives=sda

# EFI System Partition (FAT32, ~600 MiB)
#{{- if firmware == "efi" }}
# UEFI: use GPT + ESP
#clearpart --all --initlabel gpt --drives=sda

# EFI System Partition (FAT32, ~600 MiB)
part /boot/efi   --fstype=vfat  --size=600   --label=EFI-SYSTEM --fsoptions="umask=0077,shortname=winnt"
# Standard /boot partition (ext4, 1 GiB)
part /boot       --fstype=ext4  --size=1024  --label=BOOT

# LVM physical volume for everything else
part pv.01       --size=1      --grow

volgroup sysvg --pesize=4096 pv.01

# Logical volumes
logvol swap        --fstype=swap --name=lv_swap   --vgname=sysvg --size=1024   --label=SWAPFS
logvol /           --fstype=xfs  --name=lv_root   --vgname=sysvg --size=12288  --label=ROOTFS
logvol /home       --fstype=xfs  --name=lv_home   --vgname=sysvg --size=4096   --label=HOMEFS   --fsoptions="nodev,nosuid"
logvol /opt        --fstype=xfs  --name=lv_opt    --vgname=sysvg --size=2048   --label=OPTFS    --fsoptions="nodev"
logvol /tmp        --fstype=xfs  --name=lv_tmp    --vgname=sysvg --size=4096   --label=TMPFS    --fsoptions="nodev,noexec,nosuid"
logvol /var        --fstype=xfs  --name=lv_var    --vgname=sysvg --size=4096   --label=VARFS    --fsoptions="nodev"
logvol /var/log    --fstype=xfs  --name=lv_log    --vgname=sysvg --size=4096   --label=LOGFS    --fsoptions="nodev,noexec,nosuid"
logvol /var/log/audit --fstype=xfs --name=lv_audit --vgname=sysvg --size=4096 --label=AUDITFS --fsoptions="nodev,noexec,nosuid"

###############################################################################
# Bootloader
###############################################################################

# UEFI/GPT mode – installer auto-installs into the ESP
# No --location=mbr; default UEFI install will use /boot/efi
#{{- if firmware == "efi" }}
bootloader --timeout=5 --append="crashkernel=auto"
#{{- else }}
#bootloader --location=mbr --timeout=5 --append="crashkernel=auto"
#{{- end }}
###############################################################################
# Services & packages
###############################################################################

services --enabled=NetworkManager,sshd

%packages --ignoremissing --excludedocs
@core
-iwl*firmware
perl
open-vm-tools
%end

###############################################################################
# Post-install configuration
###############################################################################

%post
# Enable EPEL repo
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache

# Passwordless sudo for build user
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${build_username}
sed -i 's/^.*requiretty/# Defaults requiretty/' /etc/sudoers

# NetworkManager autoconnect workaround
for conn in /etc/NetworkManager/system-connections/*.connection; do
  grep -q '^\[connection\]' "$conn" && \
    echo 'autoconnect-priority=-999' >> "$conn"
done
systemctl restart NetworkManager
%end

reboot --eject