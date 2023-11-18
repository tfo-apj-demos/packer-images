locals {
  sources   = var.role == "base" ? ["vsphere-iso.this"] : ["vsphere-clone.this"]
}

packer {
  required_plugins {
    vsphere = {
      version = "1.2.2"
      source  = "github.com/hashicorp/vsphere"
    }

    windows-update = {
      version = "0.14.3"
      source  = "github.com/rgl/windows-update"
    }
  }
}

// Define the build
build {
  name    = "Windows Server 2022"
  sources = local.sources

  provisioner "windows-restart" {}

  provisioner "powershell" {
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
    script            = "${path.cwd}/powershell/roles/${var.role}/install-${var.role}.ps1"
  }

  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = ["exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
    "include:$true"]
    restart_timeout = "120m"
  }

  // HCP Packer Registry configuration updated for Windows
  hcp_packer_registry {
    bucket_name = "${var.role}-windows-2022"

    bucket_labels = {
      "application" = var.role
      "os"          = "Windows"
      "version"     = "2022"
    }

    build_labels = {
      "packer-build-name" = "windows-server-2022"
      "build-time"        = timestamp()
      "owner"             = var.owner
    }
  }
}