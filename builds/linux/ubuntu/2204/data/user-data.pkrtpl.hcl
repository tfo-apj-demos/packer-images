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
    ethernets:
      ens192:
        dhcp4: true
    version: 2
  packages:
    - open-vm-tools
  # refresh-installer:
  #   update: no
  ssh:
    install-server: true
    allow-pw: true
  late-commands:
    - |
      if [ -d /sys/firmware/efi ]; then
        apt-get install -y efibootmgr
        efibootmgr -o $(efibootmgr | perl -n -e '/Boot(.+)\* ubuntu/ && print $1')
      fi
  storage:
    config:
    - ptable: gpt
      path: /dev/sda
      wipe: superblock
      preserve: false
      name: ''
      grub_device: true
      type: disk
      id: disk-sda
    - device: disk-sda
      size: 1048576
      flag: bios_grub
      number: 1
      preserve: false
      grub_device: false
      type: partition
      id: partition-0
    - device: disk-sda
      size: 2147483648
      wipe: superblock
      flag: ''
      number: 2
      preserve: false
      grub_device: false
      type: partition
      id: partition-1
    - fstype: ext4
      volume: partition-1
      preserve: false
      type: format
      id: format-0
    - device: disk-sda
      size: 32209108992
      wipe: superblock
      flag: ''
      number: 3
      preserve: false
      grub_device: false
      type: partition
      id: partition-2
    - name: ubuntu-vg
      devices:
      - partition-2
      preserve: false
      type: lvm_volgroup
      id: lvm_volgroup-0
    - name: ubuntu-lv
      volgroup: lvm_volgroup-0
      size: 16101933056B
      wipe: superblock
      preserve: false
      type: lvm_partition
      id: lvm_partition-0
    - fstype: ext4
      volume: lvm_partition-0
      preserve: false
      type: format
      id: format-1
    - path: /
      device: format-1
      type: mount
      id: mount-1
    - path: /boot
      device: format-0
      type: mount
      id: mount-0
  user-data:
    disable_root: false
    timezone: ${timezone}
  version: 1
  # identity:
  #   hostname: ${hostname}
  #   username: ${username}
  #   password: ${password}
  # version: 1