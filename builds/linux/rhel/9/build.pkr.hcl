locals {
  ansible_extra_arguments = var.debug_ansible ? [
    "--extra-vars", "ansible_become_password=${var.os_password}",
    "--extra-vars", "role=${var.role}",
    "--extra-vars", "role_config='${var.role_config}'",
    "-vvv",
    "--scp-extra-args", "'-O'",
    ] : [
    "--extra-vars", "ansible_become_password=${var.os_password}",
    "--extra-vars", "role=${var.role}",
    "--extra-vars", "role_config='${var.role_config}'",
    "--extra-vars", "redhat_activation_key=${var.REDHAT_ACTIVATION_KEY}",
    "--extra-vars", "redhat_org_id=${var.REDHAT_ORG_ID}",
    "--scp-extra-args", "'-O'"
  ]
  sources = var.role == "base-rhel" ? ["vsphere-iso.this"] : ["vsphere-clone.this"]
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
      source  = "github.com/hashicorp/ansible"
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
    ]
  }

  hcp_packer_registry {
    bucket_name = "${var.role}-9"

    bucket_labels = {
      "application" = var.role
    }

    build_labels = {
      "rhel-version" = "9"
      "build-time"   = timestamp()
      "owner"        = var.owner
    }
  }
}