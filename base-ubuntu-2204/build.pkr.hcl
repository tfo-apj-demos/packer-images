locals {
	ansible_extra_arguments = var.debug_ansible ? [
			"--extra-vars", "ansible_become_password=${var.os_password}",
			"--extra-vars", "role=${var.role}",
			"-vvv",
      "--scp-extra-args", "'-O'"

    ] : [
			"--extra-vars", "ansible_become_password=${var.os_password}",
			"--extra-vars", "role=${var.role}",
      "--scp-extra-args", "'-O'"
		]
}

packer {
  required_plugins {
    vsphere = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vsphere"
    }
    amazon = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

build {
  sources = [
    "vsphere-iso.this"
  ]

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yaml"
    user          = var.os_username

    extra_arguments = local.ansible_extra_arguments

    ansible_env_vars = [
      "ANSIBLE_REMOTE_TMP=/tmp",
    ]
  }

  hcp_packer_registry {
  	bucket_name = "${var.role}-ubuntu-2204"

  	bucket_labels = {
  		"application"   = var.role
  	}

  	build_labels = {
  		"ubuntu-version" = "jammy 22.04"
  		"build-time" = timestamp()
			"owner" = var.owner
  	}
  }
}