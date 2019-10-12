# Deploy AWS VPC via Ansible

 
Author: mark
Created: 2019-03-30.20:24

Infrastructure/deploy_Aws_vpc

Based on scripts developed by https://gist.github.com/tomwwright

Steps:
- Install Ansible
- Install AWS CLI tools

- create tasks folder
- create tasks/vpc
- create playbook
- setup Inventory file

- setup scripts
- setup variables file
- setup Ansible Vault


- Run scripts

## Prerequisites

Ansible does not run on Windows. So a Linux or Mac OS machine is required.

This install is on Mac OS/Linux.

## setup

Clone this repository into an empty folder

    git clone https://github.com/transparenthealth/cdex-deploy.git

Create a Virtual Environment
    
    python3.7 -m venv env 

Activate the Virtual Environment
    
    source ./env/bin/activate
    
Upgrade Pip
    
    pip install --upgrade pip

Install Ansible

    pip install ansible
    pip install botocore
    pip install boto3
    pip install boto
    
Install AWS CLI tools

    curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "env/awscli-bundle.zip"
    cd env
    unzip awscli-bundle.zip
    sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws  
    cd ..

Test for successful AWS CLI install

    aws --version
    
The result should be something like:ansible_vault

    aws-cli/1.16.135 Python/3.7.0 Darwin/18.5.0 botocore/1.12.125
    
Create an Ansible.Vault password file:

    echo "my_vault_pass" > ./env/ansibled.vault
    ansible-vault encrypt_string "my_secret_string" --vault-password-file ./env/ansibled.vault
    
Ensure that this unecrypted file is deleted as soon as the vault 
has been populated.    

Create an AWS Key pair for the Management Server

    aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > env/MyKeyPair.pem
    
    
Edit group_vars/all.yml

    ansible_python_interpreter: {volume/folder}/env/bin/python3

Change the above line to match the location of the virtualenv 
python version.

The following example is for the dev environment in us-=east-1 region:
Run the playbook:

    cd ./deploy_aws_vpc
    ansible-playbook -i ./etc/ansible/hosts vpc.yml \
       --extra-vars "vpc_env=dev vpc_base_region=us-east \
                     vpc_number=1 aws_region=us-east-1"


### VPC Configuration

- The VPC is configured in AWS US-East-1.
- The VPC has a 10.X.0.0/16 address space.
- The VPC has subnets across three availability zones (a, b & c).
- The VPC has four areas: dmz, app, dbs and ctl

### DMZ

- The DMZ zone will be used to host the Application Load Balancers.
- 10.0.1.0/24: AZ a
- 10.0.2.0/24: AZ b
- 10.0.3.0/24: AZ c

### APP

- The APP zone will be used to host the web and app server farm.
- 10.0.4.0/24: AZ a
- 10.0.5.0/24: AZ b
- 10.0.6.0/24: AZ c

### DBS

- The DBS zone will be used to host the database servers, or connections to RDS.
- 10.0.7.0/24: AZ a
- 10.0.8.0/24: AZ b
- 10.0.9.0/24: AZ c

### CTL
- The CTL zone will be used to host management servers. Such as an ansible server that configures other devices.
- 10.0.10.0/24 AZ a
- 10.0.11.0/24 AZ b
- 10.0.12.0/24 AZ c


## SSH Access 
 
- A Security Group allows SSH (Port 22) access to all subnets

## Web Access

- A Security Group allows http and https (Port 80 & 443) access to the DMZ subnets.

## Other useful scripts
 
### Configure Standard Windows AMI
 
The standard windows AMI needs to be pre-configured using User Data.
 
This sets the server with a known password and configures WinRM enabling remote Ansible configuration.
 
This blog post details the steps needed: 
 
http://blog.rolpdog.com/2015/09/manage-stock-windows-amis-with-ansible.html
 
The complete Gist is here:
https://gist.github.com/nitzmahone/4271319ab8e7acf3330c

## Gotchas

The Internet Gateway and the NAT Gateway need to be configured in the Public subnet(s).

This means they must be defined in the DMZ zone.

The Ansible script will launch an entire VPC. The project.ansibled.yml file 
should be updated with vpc_number, vpc_name vpc_env and vpc_key

If the vpc_key already exists it will not be overwritten. 
This is the key needed to login via SSH to a server.

If you are rebuilding a VPC you may need to delete the existing VPC and
the associated route53 internal DNS settings.

The vpc_number is a unique number assigned by us to identify a VPC environment.
The currently assigned numbers are:

- 1 = us-east-1 (N. Virginia)
- 2 = us-east-2 (Ohio)


 
