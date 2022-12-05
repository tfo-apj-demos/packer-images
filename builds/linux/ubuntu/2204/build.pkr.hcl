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
    "amazon-ebs.this",
    local.base ? "vsphere-iso.this" : "vsphere-clone.this"
  ]

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yaml"
    user          = var.os_username

    extra_arguments = [
			"--extra-vars", "ansible_become_password=${var.os_password}",
			"--extra-vars", "role=${var.role}",
			"${var.debug_ansible}" ? "-vvv" : "",
    ]
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