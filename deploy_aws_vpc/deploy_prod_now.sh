#!/usr/bin/env bash
echo "Building prod vpc now"
cd /mgmt-ctrl/cdex-deploy/deploy_aws_vpc
ansible-playbook -i ./etc/ansible/hosts  ./vpc.yml --vault-password-file ../env/ansibled-prod.vault --extra-vars "vpc_env=prod vpc_base_region=us-east vpc_number=1 aws_region=us-east-1 ansible_python_interpreter=/mgmt-ctrl/cdex-deploy/env/bin/python3"  -v
echo "if there are problems running with python3 add ansible_python_interpreter={location of python3}/python3 to extra-vars"
echo "Now go to AWS Console in US-EAST-1 (N.Virginia)"
