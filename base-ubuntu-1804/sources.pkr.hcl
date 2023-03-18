locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  #vcenter_username = vault("/secret/data/hello" "foo")
  #vcenter_password = vault("/secret/data/hello" "foo")
}

source "amazon-ebs" "ubuntu-1804-base" {
  region = var.region

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
  # source = data.hcp_packer.this.id

  instance_type = "t2.medium"
  ssh_username  = "ubuntu"
  ami_name      = "${var.prefix}-${local.timestamp}"

  # ami_regions = [
  # 	"ap-southeast-1",
  # 	"ap-southeast-2"
  # ]

  tags = {
    owner         = var.owner
    application   = var.application
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
}

source "amazon-ebs" "ubuntu-1804-arm-base" {
  region = var.region

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "ubuntu/images/*ubuntu-bionic-18.04-arm64-server-*"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"] # Canonical
    most_recent = true
  }
  # source = data.hcp_packer.this.id

  instance_type = "t2.medium"
  ssh_username  = "ubuntu"
  ami_name      = "${var.prefix}-${local.timestamp}"

  # ami_regions = [
  # 	"ap-southeast-1",
  # 	"ap-southeast-2"
  # ]

  tags = {
    owner         = var.owner
    application   = var.application
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
}

source "vsphere-iso" "ubuntu-1804" {
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_insecure_connection

  vm_name   = "${var.vm_name}-${local.timestamp}"
  cluster   = var.cluster
  host      = var.host
  datastore = var.datastore

  ssh_username = "ubuntu"
  ssh_password = "Hashi123!"
  ssh_pty      = true

  guest_os_type = var.guest_os_type

  CPUs = 1
  RAM  = 1024

  RAM_reserve_all      = true
  disk_controller_type = ["pvscsi"]

  storage {
    disk_size             = 32768
    disk_thin_provisioned = true
  }

  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  iso_paths = var.iso_paths
  floppy_files = [
    var.floppy_path
  ]
  boot_command = [<<EOF
<enter><wait><f6><wait><esc><wait>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>
<bs><bs><bs>
/install/vmlinuz initrd=/install/initrd.gz priority=critical locale=en_US file=/media/preseed.cfg
<enter>
EOF
  ]
}
