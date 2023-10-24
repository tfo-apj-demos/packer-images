ubuntu_2204_base:
	packer init -var 'vcenter_username=$(VCENTER_USERNAME)' -var 'vcenter_password=$(VCENTER_PASSWORD)' -var 'vcenter_server=$(VCENTER_SERVER)' -var-file base-ubuntu-2204/base.pkrvars.hcl base-ubuntu-2204
	packer build -var 'vcenter_username=$(VCENTER_USERNAME)' -var 'vcenter_password=$(VCENTER_PASSWORD)' -var 'vcenter_server=$(VCENTER_SERVER)' -var-file base-ubuntu-2204/base.pkrvars.hcl base-ubuntu-2204


ubuntu_2204_k8s:
	packer init -var-file builds/linux/ubuntu/2204/k8s.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file builds/linux/ubuntu/2204/k8s.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_vault:
	packer init -var-file builds/linux/ubuntu/2204/vault.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file builds/linux/ubuntu/2204/vault.pkrvars.hcl builds/linux/ubuntu/2204