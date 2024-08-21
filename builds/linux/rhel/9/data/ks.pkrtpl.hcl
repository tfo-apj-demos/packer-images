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
${storage}

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
