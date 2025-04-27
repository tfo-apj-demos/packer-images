ubuntu_2204_base:
	packer init -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2404_base:
	packer init -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2404
	packer build -var-file variables/base.pkrvars.hcl builds/linux/ubuntu/2404

ubuntu_2204_base_vtpm:
	packer init -var-file variables/base_vtpm.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/base_vtpm.pkrvars.hcl builds/linux/ubuntu/2204

rhel_9_base:
	packer init -var-file variables/base_rhel.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/base_rhel.pkrvars.hcl builds/linux/rhel/9

rhel_9_base_vtpm:
	packer init -var-file variables/base_rhel_vtpm.pkrvars.hcl builds/linux/rhel/9
	packer build -var-file variables/base_rhel_vtpm.pkrvars.hcl builds/linux/rhel/9


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

ubuntu_2204_aap:
	packer init -var-file variables/aap.pkrvars.hcl builds/linux/ubuntu/2204
	packer build -var-file variables/aap.pkrvars.hcl builds/linux/ubuntu/2204

ubuntu_2204_pritunl_vpn:
	packer init -var-file variables/pritunl.pkrvars.hcl builds/linux/ubuntu/2404
	packer build -var-file variables/pritunl.pkrvars.hcl builds/linux/ubuntu/2404