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

variable "role" {
  type    = string
  default = "base"
}

variable "role_config" {
  type    = string
  default = env("ROLE_CONFIG")
}

variable "debug_ansible" {
  type    = bool
  default = false
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
  default = "Grant Orchard"
}

variable "build_sources" {
  default = [
    "vsphere-iso.this",
  ]
}

variable "os_username" {
  type    = string
  default = "ubuntu"
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

variable "vcenter_insecure_connection" {
  type    = string
  default = true
}

variable "folder" {
  type    = string
  default = "templates"
}

variable "vm_name" {
  type    = string
  default = "ubuntu-22.04-packer"
}

variable "cluster" {
  type    = string
  default = "Tenant"
}

variable "host" {
  type    = string
  default = "hltenesx01.humblelab.com"
}

variable "datastore" {
  type    = string
  default = "hl-core-ds01"
}

variable "network" {
  type    = string
  default = "VM Network"
}

variable "guest_os_type" {
  type    = string
  default = "ubuntu64Guest"
}

variable "iso_paths" {
  type    = list(string)
  default = ["[vsanDatastore] ISO/ubuntu-22.04.1-live-server-amd64.iso"]
}

variable "ansible_user_password" {
  type    = string
  default = "Hashi123!"
}

variable "os_password" {
  type    = string
  default = "Hashi123!"
}

variable "prefix" {
  type    = string
  default = "base"
}

variable "floppy_path" {
  type    = string
  default = "./preseed.cfg"
}