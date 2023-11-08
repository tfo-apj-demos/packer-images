ubuntu_2204_base:
	packer init -var-file variables/base.pkrvars.hcl base-ubuntu-2204
	packer build -var-file variables/base.pkrvars.hcl base-ubuntu-2204

ubuntu_2204_k8s:
	packer init -var-file variables/k8s.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/k8s.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_vault:
	packer init -var-file variables/vault.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/vault.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_postgres:
	packer init -var-file variables/postgres.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/postgres.pkrvars.hcl builds/linux/ubuntu/2204