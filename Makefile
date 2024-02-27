ubuntu_2204_base:
	packer init -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_k8s:
	packer init -var-file variables/k8s.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/k8s.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_vault:
	packer init -var-file variables/vault.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/vault.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_postgres:
	packer init -var-file variables/postgres.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/postgres.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_docker:
	packer init -var-file variables/docker.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/docker.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_haproxy:
	packer init -var-file variables/haproxy.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/haproxy.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_tfefdo:
	packer init -var-file variables/tfefdo.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/tfefdo.pkrvars.hcl builds/linux/ubuntu/2204

windows_2022_base:
	packer init -var-file variables/base_windows.pkrvars.hcl builds/windows/2022
	packer build -var-file variables/base_windows.pkrvars.hcl builds/windows/2022

windows_2022_mssql:
	packer init -var-file variables/mssql.pkrvars.hcl builds/windows/2022
	packer build -var-file variables/mssql.pkrvars.hcl builds/windows/2022

windows_2022_iis:
	packer init -var-file variables/iis.pkrvars.hcl builds/windows/2022
	packer build -var-file variables/iis.pkrvars.hcl builds/windows/2022

ubuntu_2204_splunk:
	packer init -var-file variables/splunk.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/splunk.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_nomad:
	packer init -var-file variables/nomad.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/nomad.pkrvars.hcl builds/linux/ubuntu/2204