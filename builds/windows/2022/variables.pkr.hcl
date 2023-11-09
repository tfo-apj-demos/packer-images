// vSphere connection details
variable "vcenter_server" {
  type = string
  default = env("VCENTER_SERVER")
}

variable "vcenter_username" {
  type = string
  default = env("VCENTER_USERNAME")
}

variable "vcenter_password" {
  type = string
  default = env("VCENTER_PASSWORD")
}

variable "vcenter_insecure_connection" {
  type    = string
  default = false
}

variable "role" {
  type    = string
  default = "base"
}

variable "region" {
  type = map(string)
  default = {
    "aws"     = "us-west-2",
    "vsphere" = "Datacenter",
    "azure"   = "australiaeast",
    "gcp"     = "australia-southeast1"
  }
}

variable "owner" {
  type    = string
  default = ""
}

variable "build_sources" {
  default = [
    "vsphere-iso.windows-server-2022"
  ]
}

variable "os_username" {
  type    = string
  default = "Administrator"
}

variable "os_timezone" {
  type        = string
  description = "The timezone to set in the guest OS."
  default     = "Pacific Standard Time"
}

variable "os_language" {
  type    = string
  default = "en-US"
}

variable "os_keyboard_layout" {
  type    = string
  default = "us"
}

variable "folder" {
  type    = string
  default = "templates"
}

variable "vm_name" {
  type    = string
  default = "win-server-2022-packer"
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

variable "guest_os_type" {
  type    = string
  default = "windows2019srv_64Guest"
}

variable "iso_paths" {
  type    = list(string)
  default = ["[vsanDatastore] ISO/en-us_windows_server_2022_updated_oct_2022_x64_dvd_c5b651c9.iso"]
}

variable "os_password" {
  type    = string
  #sensitive = true
}

variable "floppy_files" {
  type = list(string)
  default = ["./autounattend.xml", "./scripts/"]
}