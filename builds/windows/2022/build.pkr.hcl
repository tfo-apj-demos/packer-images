packer {
  required_plugins {
    vsphere = {
      version = "= 1.2.2"
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
  name = "Windows Server 2022"
  sources = [
    "source.vsphere-iso.win2022dc",
  ]
  
  provisioner "powershell" {
    inline = [
      "echo 'Processing autounattend.xml with secret...'",
      "$secret = \"${var.winrm_password}\"",
      "$xml = Get-Content -Path '${path.cwd}/builds/windows/bootfiles/2022/autounattend.xml'",
      "$xml = $xml -replace 'SECRET_PLACEHOLDER', $secret",
      "Set-Content -Path '${path.cwd}/builds/windows/bootfiles/2022/autounattend.xml' -Value $xml -Force"
    ]
  }

  provisioner "windows-restart" {}

  provisioner "powershell" {
    elevated_user     = var.winrm_username
    elevated_password = var.winrm_password
    scripts           = var.powershell_scripts
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
    bucket_name = "base-windows-2022"

    bucket_labels = {
      "application" = "base"
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
