#version=RHEL9
# Red Hat Enterprise Linux Server 9 – UEFI/GPT only

cdrom
text
eula --agreed

lang ${vm_guest_os_language}
keyboard ${vm_guest_os_keyboard}

network --bootproto=dhcp --device=ens192 --onboot=yes

rootpw --lock
user --name=${build_username} \
     --iscrypted \
     --password=${build_password_encrypted} \
     --groups=wheel

firewall --enabled --ssh
authselect select sssd
selinux --enforcing
timezone ${vm_guest_os_timezone}

# Disk setup
zerombr
clearpart --all --initlabel --drives=sda

# Standard partitions
part /boot       --fstype=ext4 --size=1024 --label=BOOTFS
part /boot/efi   --fstype=vfat --size=1024 --label=EFIFS
part pv.01       --size=100 --grow

volgroup sysvg --pesize=4096 pv.01

# Logical volumes
logvol swap        --fstype=swap --name=lv_swap   --vgname=sysvg --size=1024 --label=SWAPFS
logvol /           --fstype=xfs  --name=lv_root   --vgname=sysvg --size=12288 --label=ROOTFS
logvol /home       --fstype=xfs  --name=lv_home   --vgname=sysvg --size=4096  --label=HOMEFS   --fsoptions="nodev,nosuid"
logvol /opt        --fstype=xfs  --name=lv_opt    --vgname=sysvg --size=2048  --label=OPTFS    --fsoptions="nodev"
logvol /tmp        --fstype=xfs  --name=lv_tmp    --vgname=sysvg --size=4096  --label=TMPFS    --fsoptions="nodev,noexec,nosuid"
logvol /var        --fstype=xfs  --name=lv_var    --vgname=sysvg --size=4096  --label=VARFS    --fsoptions="nodev"
logvol /var/log    --fstype=xfs  --name=lv_log    --vgname=sysvg --size=4096  --label=LOGFS    --fsoptions="nodev,noexec,nosuid"
logvol /var/log/audit --fstype=xfs --name=lv_audit --vgname=sysvg --size=4096 --label=AUDITFS --fsoptions="nodev,noexec,nosuid"

# Install GRUB to UEFI
bootloader --location=partition --boot-drive=sda

services --enabled=NetworkManager,sshd
skipx

%packages --ignoremissing --excludedocs
@core
-iwl*firmware
perl
open-vm-tools
%end

%post
# Enable EPEL and essential tweaks
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache

# Passwordless sudo
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