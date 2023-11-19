data "hcp-packer-image" "base-windows-2022" {
  bucket_name    = "base-windows-2022"
  channel        = "latest"
  cloud_provider = "vsphere"
  region         = lookup(var.region, "vsphere", "Datacenter")
}