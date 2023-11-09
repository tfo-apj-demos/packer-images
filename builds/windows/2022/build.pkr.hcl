packer {
  required_plugins {
    vsphere = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/vsphere"
    }
  }
}

// Define the build
build {
  sources = [
    "source.vsphere-iso.windows-server-2022"
  ]

  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "${path.root}/data/sample_script.ps1"
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
