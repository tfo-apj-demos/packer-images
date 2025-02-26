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
        apt-get install -y efibootmgr
        efibootmgr -o $(efibootmgr | perl -n -e '/Boot(.+)\* ubuntu/ && print $1')
        ROOT_PART=$(mount | grep "on /target " | cut -d' ' -f1)
        sed -i "s/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"root=UUID=$(blkid -s UUID -o value $ROOT_PART)\"/" /target/etc/default/grub
        curtin in-target --target=/target -- update-grub
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