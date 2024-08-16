locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name   = "${var.role}-rhel-9-${local.timestamp}"
  base = var.role == "base"
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

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  iso_paths = var.iso_paths

  boot_command = [
    "c<wait>",
    "linux /casper/vmlinuz autoinstall quiet ---",
    "<enter><wait>",
    "initrd /casper/initrd",
    "<enter><wait>",
    "boot",
    "<enter>"
  ]

  cd_content = {
    "/meta-data" = file(abspath("${path.root}/data/meta-data"))
    "/user-data" = templatefile(abspath("${path.root}/data/user-data.pkrtpl.hcl"), {
      hostname        = local.name
      username        = var.os_username
      password        = bcrypt(var.os_password)
      timezone        = var.os_timezone
      language        = var.os_language
      keyboard_layout = var.os_keyboard_layout
    })
  }
  cd_label = "cidata"

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
  folder     = var.folder

	vm_name      = local.name
	ssh_username = var.os_username
	ssh_password = var.os_password
  temporary_key_pair_type = "ed25519"
}