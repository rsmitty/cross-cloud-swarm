# cross-cloud-swarm
An example of a multi-cloud Docker Swarm on AWS and GCE. Uses Terraform and Ansible to bootstrap.

#### Rough Instructions

*note: This set of scripts assumes that it's running in the default VPC for AWS, as well as using the default network in GCE. These things can be made configurable at some point. PRs welcome.*

##### Bootstrapping
- Source AWS API keys with `source /path/to/awscreds.sh` or `export`
- Configure defaults in `variables.tf` or override them with flags during `terraform apply`
- Plan the build with `terraform plan` and ensure it looks as expected
- Build the infrastructure with `terraform apply`
- Once built, issue `cat swarm-inventory` to ensure master and workers are populated
- Bootstrap the Swarm cluster with `ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -b -i swarm-inventory swarm.yml`

##### Teardown
- You can tear down the swarm cluster and leave the nodes for rebootstrapping with `ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -b -i swarm-inventory swarm-destroy.yml`
- Destroy all infrastructure with `terraform destroy`