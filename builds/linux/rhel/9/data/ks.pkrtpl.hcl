# Red Hat Enterprise Linux Server 9

cdrom
text
eula --agreed
lang ${vm_guest_os_language}
keyboard ${vm_guest_os_keyboard}

${network}

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
%end

%post
/usr/sbin/subscription-manager register --username ${rhsm_username} --password ${rhsm_password} --autosubscribe --force
/usr/sbin/subscription-manager repos --enable "codeready-builder-for-rhel-9-x86_64-rpms"
dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
dnf makecache
dnf install -y sudo open-vm-tools perl
%{ if additional_packages != "" ~}
dnf install -y ${additional_packages}
%{ endif ~}
echo "${build_username} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${build_username}
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
%end

reboot --eject
