locals {
	ansible_extra_arguments = var.debug_ansible ? [
			"--extra-vars", "ansible_become_password=${var.os_password}",
			"--extra-vars", "role=${var.role}",
      "--extra-vars", "CONTROLLER_PASSWORD='${var.controller_password}'",
      "--extra-vars", "role_config='${var.role_config}'",
			"-vvv",
      "--scp-extra-args", "'-O'"

    ] : [
			"--extra-vars", "ansible_become_password=${var.os_password}",
			"--extra-vars", "role=${var.role}",
      "--extra-vars", "role_config='${var.role_config}'",
      "--extra-vars", "CONTROLLER_PASSWORD='${var.controller_password}'",
      "--scp-extra-args", "'-O'"
		]
  sources = var.role == "base" ? [ "vsphere-iso.this" ] : [ "vsphere-clone.this" ]
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
    
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

build {
  sources = local.sources

  provisioner "ansible" {
    playbook_file = "${path.cwd}/ansible/playbook.yaml"
    user          = var.os_username

    extra_arguments = local.ansible_extra_arguments

    ansible_env_vars = [
      "ANSIBLE_REMOTE_TMP=/tmp",
      "CONTROLLER_HOST=${var.controller_host}",
      "CONTROLLER_PASSWORD=${var.controller_password}"
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