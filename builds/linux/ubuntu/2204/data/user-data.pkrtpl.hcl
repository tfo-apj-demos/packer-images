#cloud-config
autoinstall:
  apt:
    geoip: true
    preserve_sources_list: false
    primary:
      - arches: [amd64, i386]
        uri: http://us.archive.ubuntu.com/ubuntu
      - arches: [default]
        uri: http://ports.ubuntu.com/ubuntu-ports
  # drivers:
  #   install: false
  early-commands:
    - sudo systemctl stop ssh
  late-commands:
    - |
      if [ -d /sys/firmware/efi ]; then
       sudo grub-install --target=x86_64-efi --recheck /dev/sda
       update-grub
      fi
  identity:
    hostname: ${hostname}
    username: ${username}
    password: ${password}
  # kernel:
  #   package: linux-generic
  keyboard:
    layout: ${keyboard_layout}
  locale: ${language}
  network:
    version: 2
    ethernets:
      ens192:
        dhcp4: true
        dhcp6: false
        optional: true
  packages:
    - open-vm-tools
  # refresh-installer:
  #   update: no
  ssh:
    install-server: true
    allow-pw: true
  user-data:
    disable_root: false
    timezone: ${timezone}
  version: 1