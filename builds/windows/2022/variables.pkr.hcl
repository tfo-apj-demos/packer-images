# vCenter Credentials
variable "vcenter_server" {
  description = "The FQDN of the vCenter Packer will connect to"
  type        = string
  default     = env("VCENTER_SERVER")

}

variable "vcenter_username" {
  type    = string
  default = env("VCENTER_USERNAME")
}

variable "vcenter_password" {
  type    = string
  default = env("VCENTER_PASSWORD")
}

variable "vcenter_sslconnection" {
  description = "Is the connection to vCenter secure or not"
  type        = bool
  default     = false
}

variable "region" {
  type = map(string)
  default = {
    "aws"     = "us-west-2",
    "vsphere" = "Datacenter",
    "azure"   = "australiaeast"
  }
}

variable "cluster" {
  description = "The name of the Cluster in vCenter Packer will build in"
  type        = string
}

variable "datastore" {
  description = "The name of the Datastore in vCenter Packer will build in"
  type        = string
}

variable "network" {
  description = "The name of the network that the VM will connect to"
  type        = string
}

variable "folder" {
  description = "The name of the Folder in vCenter Packer will build in"
  type        = string
  default = "templates"
}

# VM Hardware Configuration

variable "guest_os_type" {
  description = "The Guest OS identifier for the VM"
  type        = string
  default = "windows9Server64Guest"
}

variable "vm_firmware" {
  description = "The firmware type for the VM - BIOS/EFI"
  type        = string
  default     = "efi"
}

variable "vm_hardware_version" {
  description = "The VM hardware version"
  type        = number
  default = 17
}

variable "vm_cpu_sockets" {
  description = "The number of CPU sockets for the VM"
  type        = number
  default     = 2
}

variable "vm_cpu_cores" {
  description = "The number of CPU cores for the VM"
  type        = number
  default     = 1
}

variable "vm_ram" {
  description = "The amount of RAM in Mb for the VM"
  type        = number
  default     = 4096
}

variable "vm_nic_type" {
  description = "The NIC Type (vmxnet3, e1000, etc.) for the VM"
  type        = string
  default     = "vmxnet3"
}

variable "template" {
  description = "The template to use for any clone (role) based deployment"
  type = string
  default = ""
}

variable "vm_disk_controller" {
  description = "The disk controller type for the VM"
  type        = list(string)
  default     = ["pvscsi"]
}

variable "vm_disk_size" {
  description = "The size of the disk (C:) for the VM"
  type        = number
  default     = 61440
}

variable "vm_disk_thin" {
  description = "Should the disk be thin provision on the VM"
  type        = bool
  default     = true
}

variable "config_parameters" {
  description = "The list of extra configuration parameters to add to the vmx file"
  type        = map(string)
  default = {
        "devices.hotplug" = "FALSE",
        "guestInfo.svga.wddm.modeset" = "FALSE",
        "guestInfo.svga.wddm.modesetCCD" = "FALSE",
        "guestInfo.svga.wddm.modesetLegacySingle" = "FALSE",
        "guestInfo.svga.wddm.modesetLegacyMulti" = "FALSE"
  }
}

# Removable Media Configuration

variable "vcenter_iso_datastore" {
  description = "The name of the Datastore in vCenter the ISOs are located on"
  type        = string
  default = "vsanDatastore"
}

variable "iso_path" {
  description = "The path to the ISO file to be used for OS installation"
  type        = string
  default = "ISO"
}

variable "os_iso_file" {
  description = "The name to the ISO file to be used for OS installation"
  type        = string
  default = ""
}

variable "role_iso_file" {
  description = "The name to the ISO file to be used for OS installation"
  type        = string
  default = ""
}

variable "vmtools_iso_file" {
  description = "The name to the ISO file to be used for VMware Tools installation"
  type        = string
  default = ""
}

variable "vm_cdrom_remove" {
  description = "Should the CDROMs be removed from the VM once build is complete"
  type        = bool
  default     = true
}

# Build Settings

variable "vm_convert_template" {
  description = "Convert the VM to a template"
  type        = bool
  default     = true
}

variable "winrm_username" {
  description = "The winrm username that is used to connect to the VM. This should match the Autounattend.xml"
  type        = string
  default     = "Administrator"
  sensitive   = true
}

variable "winrm_password" {
  description = "The winrm password that is used to connect to the VM. This should match the Autounattend.xml"
  type        = string
  sensitive   = true
  default     = env("WINDOWS_PASSWORD")
}

# Provisioner Settings

variable "powershell_scripts" {
  description = "The list of PowerShell scripts to run when the OS is ready"
  type        = list(string)
}

variable "owner" {
  type = string
}

variable "role" {
  type        = string
  description = "The application to trigger as part of the build process."
}