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
    # BIOS boot needs a small unformatted partition flagged for bios_grub
    - device: disk-sda
      size: 1048576       # 1 MiB (adjust if needed)
      flag: bios_grub
      number: 1
      preserve: false
      grub_device: false
      type: partition
      id: partition-bios
    # EFI systems require an EFI System Partition (ESP)
    - device: disk-sda
      size: 524288000     # ~500 MiB; adjust as required
      flag: boot,esp
      number: 2
      preserve: false
      grub_device: true
      type: partition
      id: partition-efi
    - fstype: fat32
      volume: partition-efi
      preserve: false
      type: format
      id: format-efi
    # /boot partition (for kernel and initrd)
    - device: disk-sda
      size: 2147483648    # ~2 GiB; adjust as needed
      wipe: superblock
      flag: ''
      number: 3
      preserve: false
      grub_device: false
      type: partition
      id: partition-boot
    - fstype: ext4
      volume: partition-boot
      preserve: false
      type: format
      id: format-boot
    # LVM partition for the main OS
    - device: disk-sda
      size: 32209108992   # main partition size; adjust as required
      wipe: superblock
      flag: ''
      number: 4
      preserve: false
      grub_device: false
      type: partition
      id: partition-lvm
    - name: ubuntu-vg
      devices:
      - partition-lvm
      preserve: false
      type: lvm_volgroup
      id: lvm_volgroup-0
    - name: ubuntu-lv
      volgroup: lvm_volgroup-0
      size: 16101933056B  # root volume size; adjust as needed
      wipe: superblock
      preserve: false
      type: lvm_partition
      id: lvm_partition-root
    - fstype: ext4
      volume: lvm_partition-root
      preserve: false
      type: format
      id: format-root
    - path: /
      device: format-root
      type: mount
      id: mount-root
    - path: /boot
      device: format-boot
      type: mount
      id: mount-boot
    - path: /boot/efi
      device: format-efi
      type: mount
      id: mount-efi
  user-data:
    disable_root: false
    timezone: ${timezone}
  version: 1
  # identity:
  #   hostname: ${hostname}
  #   username: ${username}
  #   password: ${password}
  # version: 1