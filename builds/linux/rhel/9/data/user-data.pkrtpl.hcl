#cloud-config
hostname: ${hostname}
users:
  - default
  - name: ${username}
    lock_passwd: false
    passwd: ${password}
    groups: [wheel]
    shell: /bin/bash
chpasswd:
  list: |
    ${username}:${password}
  expire: False
timezone: ${timezone}
locale: ${language}.UTF-8
keyboard:
  layout: ${keyboard_layout}
package_upgrade: true
packages:
  - cloud-init
  - open-vm-tools
  - epel-release
  - git
  - vim
  - wget
  - curl
runcmd:
  - systemctl enable vmtoolsd
  - systemctl start vmtoolsd
  - systemctl restart sshd
  - systemctl enable sshd
  - firewall-cmd --permanent --add-service=ssh
  - firewall-cmd --reload
  - yum -y install cloud-init
  - systemctl enable cloud-init
  - reboot
