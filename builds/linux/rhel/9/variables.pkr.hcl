// vSphere connection details
variable "vcenter_server" {
  type    = string
  default = env("VCENTER_SERVER")
}

variable "vcenter_username" {
  type    = string
  default = env("VCENTER_USERNAME")
}

variable "vcenter_password" {
  type    = string
  default = env("VCENTER_PASSWORD")
}

variable "role_config" {
  type    = string
  default = env("ROLE_CONFIG")
}

variable "vcenter_insecure_connection" {
  type    = string
  default = false
}

// Users and connectivity
variable "os_username" {
  type    = string
  default = "vm_user"
}

variable "os_password" {
  type    = string
  default = env("LINUX_PASSWORD")
}

// Where to build
variable "region" {
  type = map(string)
  default = {
    "aws"     = "us-west-2",
    "vsphere" = "Datacenter",
    "azure"   = "australiaeast"
  }
}

variable "cluster" {
  type = string
}

variable "datastore" {
  type = string
}

variable "network" {
  type = string
}

variable "folder" {
  type    = string
  default = "templates"
}

// Virtual machine configuration

# variable "prefix" {
# 	type = string
# }

variable "guest_os_type" {
  type    = string
  default = "rhel9_64Guest"
}

variable "iso_paths" {
  type    = list(string)
  default = ["[vsanDatastore] ISO/rhel-9.4-x86_64-dvd.iso"]
}

variable "os_timezone" {
  type        = string
  description = "The timezone to set in the guest OS. Check https://manpages.ubuntu.com/manpages/bionic/man3/DateTime::TimeZone::Catalog.3pm.html for values."
  default     = "Australia/Sydney"
}

variable "os_language" {
  type    = string
  default = "en_US"
}

variable "os_keyboard_layout" {
  type    = string
  default = "us"
}

// Metadata
variable "owner" {
  type = string
}

variable "project_id" {
  type = string
}

variable "role" {
  type        = string
  description = "The Ansible roles to trigger as part of the build process."
}

variable "debug_ansible" {
  type    = bool
  default = false
}

variable "vm_network_device" {
  type        = string
  description = "The network device of the VM."
  default     = "ens192"
}

variable "vm_ip_address" {
  type        = string
  description = "The IP address of the VM (e.g. 172.16.100.192)."
  default     = null
}

variable "vm_ip_netmask" {
  type        = number
  description = "The netmask of the VM (e.g. 24)."
  default     = 24
}

variable "vm_ip_gateway" {
  type        = string
  description = "The gateway of the VM (e.g. 172.16.100.1)."
  default     = null
}

variable "vm_dns_list" {
  type        = list(string)
  description = "The nameservers of the VM."
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "vm_disk_device" {
  type        = string
  description = "The device for the virtual disk. (e.g. 'sda')"
  default     = "sda"
}

variable "vm_disk_use_swap" {
  type        = bool
  description = "Whether to use a swap partition."
  default     = true
}

variable "vm_disk_partitions" {
  type = list(object({
    name = string
    size = number
    format = object({
      label  = string
      fstype = string
    })
    mount = object({
      path    = string
      options = string
    })
    volume_group = string
  }))
  description = "The disk partitions for the virtual disk."
  default     = [
    {
      name         = "boot"
      size         = 1024
      format       = { label = "boot", fstype = "ext4" }   # Comma added here
      mount        = { path = "/boot", options = "defaults" }
      volume_group = ""
    },
    {
      name         = "root"
      size         = -1
      format       = { label = "root", fstype = "xfs" }   # Comma added here
      mount        = { path = "/", options = "defaults" }
      volume_group = ""
    }
  ]
}

variable "vm_disk_lvm" {
  type = list(object({
    name = string
    partitions = list(object({
      name = string
      size = number
      format = object({
        label  = string
        fstype = string
      })
      mount = object({
        path    = string
        options = string
      })
    }))
  }))
  description = "The LVM configuration for the virtual disk."
  default     = []
}

variable "additional_packages" {
  type        = list(string)
  description = "Additional packages to install."
  default     = []
}