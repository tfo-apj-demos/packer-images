ubuntu_2204_base:
	packer init -var-file base-ubuntu-2204/base.pkrvars.hcl base-ubuntu-2204
	packer build -var-file base-ubuntu-2204/base.pkrvars.hcl base-ubuntu-2204


ubuntu_2204_k8s:
	packer init -var-file builds/linux/ubuntu/2204/k8s.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file builds/linux/ubuntu/2204/k8s.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_vault:
	packer init -var-file builds/linux/ubuntu/2204/vault.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file builds/linux/ubuntu/2204/vault.pkrvars.hcl builds/linux/ubuntu/2204