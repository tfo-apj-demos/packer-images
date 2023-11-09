source "vsphere-iso" "windows-server-2022" {
  // Connection details
  username            = var.vcenter_username
  password            = var.vcenter_password
  vcenter_server      = var.vcenter_server
  insecure_connection = var.vcenter_insecure_connection

  // Set the communicator to WinRM for Windows
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

  // VM hardware specifications
  CPUs                = 2
  RAM                 = 4096
  RAM_reserve_all     = true
  disk_controller_type= ["pvscsi"]

  // VM storage configuration
  storage {
    disk_size             = 51200 // Recommended size for Windows Server 2022
    disk_thin_provisioned = true
  }

  // VM network configuration
  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  // ISO configuration
  iso_paths = var.iso_paths

  // Include autounattend.xml and scripts on a virtual CD-ROM
  cd_files = [
    "${path.root}/data/autounattend.xml",
    "${path.root}/data/scripts/*"
  ]
  cd_label = "WIN_INSTALL"
}
