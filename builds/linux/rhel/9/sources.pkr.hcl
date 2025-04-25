locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "${var.role}-9-${local.timestamp}"
  base      = var.role == "base-rhel"

  // New variables for Kickstart configuration
  data_source_content = {
    "/ks.cfg" = templatefile("${abspath(path.root)}/data/ks.pkrtpl.hcl", {
      build_username           = var.os_username
      build_password           = var.os_password
      build_password_encrypted = bcrypt(var.os_password)
      #rhsm_username            = var.rhsm_username
      #rhsm_password            = var.rhsm_password
      vm_guest_os_language     = var.os_language
      vm_guest_os_keyboard     = var.os_keyboard_layout
      vm_guest_os_timezone     = var.os_timezone
      storage = templatefile("${abspath(path.root)}/data/storage.pkrtpl.hcl", {
        device     = var.vm_disk_device
        swap       = var.vm_disk_use_swap
        partitions = var.vm_disk_partitions
        lvm        = var.vm_disk_lvm
      })
      additional_packages = join(" ", var.additional_packages)
    })
  }
  data_source_command = "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg"

  ### Below are the boot commands for the different types of booting
  # BIOS (legacy) + CDROM:
  bios_boot_command = [
    "<up><wait><tab><wait> inst.text inst.ks=cdrom:/ks.cfg <enter><wait>"
  ]                                        # uses <tab> to get to the prompt and cdrom:/ks.cfg :contentReference[oaicite:0]{index=0}

  # UEFI + CDROM:
  efi_boot_command = [
    "e<wait>",                             # press “e” to edit the GRUB entry :contentReference[oaicite:1]{index=1}
    "<down><down><end><wait> inst.text inst.ks=cdrom:/ks.cfg inst.gpt inst.efi",
                                           # append your install flags + GPT/EFI auto‐partition :contentReference[oaicite:2]{index=2}
    "<ctrl>x<wait>"                        # Ctrl-X to boot with the edited line :contentReference[oaicite:3]{index=3}
  ]
}

source "vsphere-iso" "this" {
  // Connection details
  username            = var.vcenter_username
  password            = var.vcenter_password
  vcenter_server      = var.vcenter_server
  insecure_connection = var.vcenter_insecure_connection


  // Where to build
  datacenter = lookup(var.region, "vsphere", "Datacenter")
  cluster    = var.cluster
  datastore  = var.datastore
  folder     = var.folder

  // Virtual machine configuration
  convert_to_template = true
  vm_name             = local.name
  guest_os_type       = var.guest_os_type

  CPUs = 2
  RAM  = 4096

  RAM_reserve_all      = true
  disk_controller_type = ["pvscsi"]

  vTPM = var.enable_vtpm
  firmware = var.firmware

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  iso_paths = var.iso_paths
  http_interface = "ens192"
  cd_content = local.data_source_content
  // Updated boot_command
  #boot_command = ["<up><wait><tab><wait> inst.text inst.ks=cdrom:/ks.cfg <enter><wait>"]
  boot_command = var.firmware == "efi" ? local.efi_boot_command : local.bios_boot_command

  // Serve Kickstart file via HTTP
  #http_content = local.data_source_content

  // Post build connectivity
  ssh_username           = var.os_username
  ssh_password           = var.os_password
  ssh_pty                = true
  ssh_timeout            = "30m"
  ssh_handshake_attempts = 1000
}

source "vsphere-clone" "this" {
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_insecure_connection

  convert_to_template = true

  template  = data.hcp-packer-image.vsphere.id
  cluster   = var.cluster
  datastore = var.datastore
  folder    = var.folder

  vm_name                 = local.name
  ssh_username            = var.os_username
  ssh_password            = var.os_password
  temporary_key_pair_type = "ed25519"
}