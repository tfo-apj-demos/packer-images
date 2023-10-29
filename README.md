[![Build VMware Images](https://github.com/tfo-apj-demos/packer-images/actions/workflows/packer-builds.yml/badge.svg)](https://github.com/tfo-apj-demos/packer-images/actions/workflows/packer-builds.yml)

# About this project
This repo contains a set of reusable Packer builds for multiple target platforms.
It includes integration for HCP Packer, to give you the building blocks to demonstrate core workflow challenges around image management including revocation and ancestry.

# Usage
In an attempt to simplify the structure of this as much as possible, a Makefile is used to abstract the need to understand the Packer CLI arguments.

You can trigger a build with the following example command from the root directory `make base-ubuntu-2204`.

# Known issues
Attempting to use the Ansible provisioner with Ubuntu 22.04 throws the following error:
```
vsphere-iso.this: fatal: [default]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via ssh: Unable to negotiate with 127.0.0.1 port 53717: no matching host key type found. Their offer: ecdsa-sha2-nistp384", "unreachable": true}
```

Make sure that your SSH config ($HOME/.ssh/config) has the necessary HostKeyAlgorithm defined. For example:
```
Host *
   HostKeyAlgorithms ecdsa-sha2-nistp384
```

Ansible run fails at gathering facts stage.
```
TASK [Gathering Facts] *********************************************************
    vsphere-iso.this: fatal: [default]: UNREACHABLE! => {"changed": false, "msg": "Failed to connect to the host via scp: scp: Connection closed\r\n", "unreachable": true}
```
This has been addressed by adding `"--scp-extra-args", "'-O'"` to our ansible_extra_arguments block in local variables.