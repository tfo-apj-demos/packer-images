# Red Hat Enterprise Linux Server 9
cdrom
text
eula --agreed
lang ${vm_guest_os_language}
keyboard ${vm_guest_os_keyboard}

network --bootproto=dhcp --device=ens192 --onboot=yes

rootpw --lock
user --name=${build_username} --iscrypted --password=${build_password_encrypted} --groups=wheel
firewall --enabled --ssh
authselect select sssd
selinux --enforcing
timezone ${vm_guest_os_timezone}
#${storage}
### Initialize any invalid partition tables found on disks.
zerombr

### Removes partitions from the system, prior to creation of new partitions. 
### By default, no partitions are removed.
### --linux	erases all Linux partitions.
### --initlabel Initializes a disk (or disks) by creating a default disk label for all disks in their respective architecture.
clearpart --all --initlabel

### Modify partition sizes for the virtual machine hardware.
### Create primary system partitions.
part /boot --fstype xfs --size=1024 --label=BOOTFS
part /boot/efi --fstype vfat --size=1024 --label=EFIFS
part pv.01 --size=100 --grow

### Create a logical volume management (LVM) group.
volgroup sysvg --pesize=4096 pv.01

### Modify logical volume sizes for the virtual machine hardware.
### Create logical volumes.
logvol swap --fstype swap --name=lv_swap --vgname=sysvg --size=1024 --label=SWAPFS
logvol / --fstype xfs --name=lv_root --vgname=sysvg --size=12288 --label=ROOTFS
logvol /home --fstype xfs --name=lv_home --vgname=sysvg --size=4096 --label=HOMEFS --fsoptions="nodev,nosuid"
logvol /opt --fstype xfs --name=lv_opt --vgname=sysvg --size=2048 --label=OPTFS --fsoptions="nodev"
logvol /tmp --fstype xfs --name=lv_tmp --vgname=sysvg --size=4096 --label=TMPFS --fsoptions="nodev,noexec,nosuid"
logvol /var --fstype xfs --name=lv_var --vgname=sysvg --size=4096 --label=VARFS --fsoptions="nodev"
logvol /var/log --fstype xfs --name=lv_log --vgname=sysvg --size=4096 --label=LOGFS --fsoptions="nodev,noexec,nosuid"
logvol /var/log/audit --fstype xfs --name=lv_audit --vgname=sysvg --size=4096 --label=AUDITFS --fsoptions="nodev,noexec,nosuid"

services --enabled=NetworkManager,sshd
skipx

%packages --ignoremissing --excludedocs
@core
-iwl*firmware
perl
open-vm-tools
%end

%post
# Install necessary packages
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache
# dnf install -y sudo open-vm-tools perl
%{ if additional_packages != "" ~}
dnf install -y ${additional_packages}
%{ endif ~}
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${build_username}
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Workaround: Set autoconnect-priority in NetworkManager connections
for conn_file in /etc/NetworkManager/system-connections/*.connection; do
    if grep -q "\[connection\]" "$conn_file"; then
        echo "autoconnect-priority=-999" >> "$conn_file"
    fi
done

# Restart NetworkManager to apply changes
systemctl restart NetworkManager
%end

reboot --eject
