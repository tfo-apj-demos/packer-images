variable "region" {
  type    = string
  default = "us-west-2"
}

variable "owner" {
  type    = string
  default = "Grant Orchard"
}

variable "vcenter_server" {
  type    = string
  default = ""
}

variable "vcenter_username" {
  type    = string
  default = ""
}

variable "vcenter_password" {
  type    = string
  default = ""
}

variable "vcenter_insecure_connection" {
  type    = string
  default = true
}

variable "vm_name" {
  type    = string
  default = "ubuntu-18.04-packer"
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
  default = ["[hl-core-ds02] ISO/ubuntu-18.04.4-server-amd64.iso"]
}

variable "vault_addr" {
  type    = string
  default = "https://127.0.0.1:8200"
}

variable "ansible_user_password" {
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

variable "application" {
  type    = string
  default = ""
}

variable "consul_config" {
  type = string
}

variable "consul_ca" {
  type = string
}

variable "consul_license" {
  type = string
}