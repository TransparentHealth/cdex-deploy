#!/usr/bin/env bash
cd /mgmt-ctrl/Infrastructure/deploy_aws_vpc
ansible-playbook -i ./etc/ansible/hosts  ./deploy_server.yml --vault-id ~/ansibled.vault --extra-vars "vpc_env=prod vpc_base_region=us-east vpc_number=1 aws_region=us-east-1"  -v
echo "Now go to AWS Console in US-EAST-1 (N.Virginia)"
echo "Add new servers to PROD-WEB target group"
echo "Remove old servers from PROD-WEB Target Group and terminate"
