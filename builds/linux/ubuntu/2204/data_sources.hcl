data "hcp-packer-image" "aws" {
	count = local.base ? 0 : 1
  bucket_name = data.hcp-packer-iteration.this.bucket_name
  iteration_id = data.hcp-packer-iteration.this.id
  cloud_provider = "aws"
  region = lookup(var.region, "aws", "us-west-2")
}

data "hcp-packer-image" "vsphere" {
	count = local.base ? 0 : 1
  bucket_name = data.hcp-packer-iteration.this.bucket_name
  iteration_id = data.hcp-packer-iteration.this.id
  cloud_provider = "aws"
  region = lookup(var.region, "vsphere", "Datacenter")
}