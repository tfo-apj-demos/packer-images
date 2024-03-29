locals {
  timestamp     = regex_replace(timestamp(), "[- TZ:]", "")
  name          = "${var.role}-windows-2022-${local.timestamp}"
  build_version = formatdate("YY.MM", timestamp())
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

source "vsphere-iso" "this" {
  // Connection details
  username            = var.vcenter_username
  password            = var.vcenter_password
  vcenter_server      = var.vcenter_server
  insecure_connection = var.vcenter_sslconnection

  // Where to build
  datacenter = lookup(var.region, "vsphere", "Datacenter")
  cluster    = var.cluster
  datastore  = var.datastore
  folder     = var.folder

  # Virtual Machine configuration
  convert_to_template = var.vm_convert_template

  vm_name         = local.name
  notes           = "Version: ${local.build_version}\nBuild Time: ${local.build_date}\nOS: Windows Server 2022 Datacenter"
  guest_os_type   = var.guest_os_type
  firmware        = var.vm_firmware
  vm_version      = var.vm_hardware_version
  CPUs            = var.vm_cpu_sockets
  cpu_cores       = var.vm_cpu_cores
  RAM             = var.vm_ram
  RAM_reserve_all = true

  network_adapters {
    network_card = var.vm_nic_type
    network      = var.network
  }

  disk_controller_type = var.vm_disk_controller
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin
  }

  configuration_parameters = var.config_parameters

  # Removable Media Configuration
  iso_paths = var.iso_paths
  floppy_files = [
    "${path.cwd}/builds/windows/bootfiles/2022/autounattend.xml",
    "${path.cwd}/builds/windows/bootfiles/2022/install-vmtools64.cmd",
    "${path.cwd}/builds/windows/bootfiles/2022/initial-setup.ps1"
  ]

  remove_cdrom = var.vm_cdrom_remove

  # Build Settings
  boot_command     = ["<spacebar>"]
  boot_wait        = "1s"
  ip_wait_timeout  = "20m"
  communicator     = "winrm"
  winrm_timeout    = "8h"
  winrm_username   = var.winrm_username
  winrm_password   = var.winrm_password
  shutdown_command = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Build Complete\""
  shutdown_timeout = "1h"
}

source "vsphere-clone" "this" {
  vcenter_server = var.vcenter_server
  username       = var.vcenter_username
  password       = var.vcenter_password

  convert_to_template = var.vm_convert_template

  vm_name   = local.name
  notes     = "Version: ${local.build_version}\nBuild Time: ${local.build_date}\nOS: Windows Server 2022 Datacenter\nApplication: ${var.role}"
  template  = data.hcp-packer-image.base-windows-2022.id
  cluster   = var.cluster
  datastore = var.datastore
  folder    = var.folder

 # Application dependencies 
  iso_paths = var.role_iso_file != "" ? [var.role_iso_file] : [] 
  floppy_files = [
    "${path.cwd}/powershell/roles/${var.role}/${var.role_configuration_file}",
  ]

  communicator   = "winrm"
  winrm_timeout  = "4h"
  winrm_username = var.winrm_username
  winrm_password = var.winrm_password
}