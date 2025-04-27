// data "hcp-packer-image" "aws" {
//   bucket_name = "base-ubuntu-2204"
// 	channel = "latest"
//   cloud_provider = "aws"
//   region = lookup(var.region, "aws", "us-west-2")
// }

data "hcp-packer-image" "vsphere" {
  bucket_name = "base-ubuntu-2404"
	channel = "latest"
  cloud_provider = "vsphere"
  region = lookup(var.region, "vsphere", "Datacenter")
}