# About this project
This repo contains a set of reusable Packer builds for multiple target platforms.
It includes integration for HCP Packer, to give you the building blocks to demonstrate core workflow challenges around image management including revocation and ancestry.

# Usage
In an attempt to simplify the structure of this as much as possible, the build definitions expect to be provided with an Ansible role (which you can find in the "roles" directory.) Providing the `role=base` will trigger a vanilla build, and configure the image for use with HashiCorp repositories, allowing for subsequent child builds of our products. One special case associated with this is that a base build will trigger a "build from scratch" image on VMware, using an ISO read from a datastore. Child images on VMware will clone from the base build, for a much faster build time.

You can trigger a build with the following command from the root directory `packer build builds/linux/ubuntu/2204 -var-file=<path to your var file>` or alternatively create a `variables.auto.pkrvars.hcl` file in the directory of the build you intend to reuse and run `packer build builds/linux/ubuntu/2204`.