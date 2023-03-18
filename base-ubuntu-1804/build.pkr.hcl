build {
  sources = [
    # "vsphere-iso.ubuntu-1804",
    "amazon-ebs.ubuntu-1804-base",
    #"amazon-ebs.ubuntu-1804-arm-base"
  ]
  hcp_packer_registry {
    bucket_name = "base-ubuntu-1804"
    description = "Base Ubuntu 18.04 image"
    labels = {
      "owner" = "Grant Orchard"
    }
  }
  provisioner "ansible" {
    playbook_file = "./playbooks/playbook.yaml"
    user          = "ubuntu"
    extra_arguments = [
      "--extra-vars",
      "role=${var.role}"
    ]
  }
}
