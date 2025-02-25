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
  default = "ubuntu"
}

variable "os_password" {
  type = string
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
  default = "ubuntu64Guest"
}

variable "iso_paths" {
  type    = list(string)
  default = ["[vsanDatastore] ISO/ubuntu-22.04.1-live-server-amd64.iso"]
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
	type = bool
	default = false
}

variable "enable_vtpm" {
  type = bool
  default = false
}