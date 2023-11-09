locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "${var.role}-windows-2022-${local.timestamp}"
}

source "vsphere-iso" "windows-server-2022" {
  // Connection details
  username            = var.vcenter_username
  password            = var.vcenter_password
  vcenter_server      = var.vcenter_server
  insecure_connection = var.vcenter_insecure_connection
  
  communicator  = "winrm"
  winrm_username = "Administrator"
  winrm_password = "Hashi123!"
  winrm_timeout  = "6h"

  // Where to build
  datacenter = lookup(var.region, "vsphere", "Datacenter")
  cluster    = var.cluster
  datastore  = var.datastore
  folder     = var.folder

  // Virtual machine configuration
  convert_to_template = true
  vm_name             = local.name
  guest_os_type       = var.guest_os_type

  CPUs                = 2
  RAM                 = 4096
  RAM_reserve_all     = true
  disk_controller_type= ["pvscsi"]

  storage {
    disk_size             = 51200 // Recommended size for Windows Server 2022
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  iso_paths = var.iso_paths

  // Remove boot command for Windows. It uses an autounattend.xml file.
  // cd_content will reference the necessary autounattend.xml and supporting scripts.

  cd_files = ["${path.root}/data/autounattend.xml", "${path.root}/data/scripts/*"]
  cd_label = "WIN_INSTALL"

  // Post build connectivity - using WinRM for Windows instead of SSH
  /*winrm_username = var.os_username
  winrm_password = var.os_password
  winrm_timeout  = "6h" // Windows updates can take a long time*/
}