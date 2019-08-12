#!/usr/bin/env bash
cd /mgmt-ctrl/Infrastructure/deploy_aws_vpc
ansible-playbook -i ./etc/ansible/hosts  ./vpc.yml --vault-password-file ../env/ansibled.vault --extra-vars "vpc_env=staging vpc_base_region=us-east vpc_number=1 aws_region=us-east-1"  -v
echo "if there are problems running with python3 add ansible_python_interpreter={location of python3}/python3 to extra-vars"
echo "Now go to AWS Console in US-EAST-1 (N.Virginia)"
echo "Add new servers to PROD-WEB target group"
echo "Remove old servers from PROD-WEB Target Group and terminate"
