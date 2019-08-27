#!/usr/bin/env bash
echo "Building staging vpc now"
cd /mgmt-ctrl/cdex-deploy/deploy_aws_vpc
ansible-playbook   ./vpc.yml --vault-password-file ../env/ansibled-staging.vault --extra-vars "vpc_env=staging vpc_base_region=us-east vpc_number=1 aws_region=us-east-1 ansible_python_interpreter=/mgmt-ctrl/cdex-deploy/env/bin/python3"  -vvvv
echo "if there are problems running with python3 add ansible_python_interpreter={location of python3}/python3 to extra-vars"
echo "Now go to AWS Console in US-EAST-1 (N.Virginia)"
