# Accessing the Alliance Fro Better Health Management Controller 

The Management Controller is used to deploy updates to the 
Alliance For Better Health STAGING and PROD environments.


## Connecting to the Management Controller


     ssh -i ~/.ec2/abhealth/mgmt-controller.pem ubuntu@ec2-100-24-20-110.compute-1.amazonaws.com


Scripts are installed in /mgmt-ctrl

## Manual Process for Login

- ssh to the mgmt-ctrl server with the ubuntu account.
- check if packages or updates need to be applied


## Applying security updates and patches to mgmt-ctrl

    sudo apt-get upgrade
    sudo apt-det update
    sudo reboot
    
Wait 30-60 seconds and reconnect to the server with ssh.

Check if all necessary patches have been applied.
If there are still updates outstanding then run the following command:

    sudo apt-get dist-upgrade
    sudo reboot
    
## Performing a scripted update to the staging and/or prod environment

The following commands should be run at the start of an update session after logging in and applying any security updates:

    cd /mgmt-ctrl/cdex-deploy/deploy_aws_vpc/
    source ../env/bin/activate

This activates a Python 3.6 virtual environment that is isolated from 
the system environment and python version.

The requisite packages from Ansible (2.8) have been installed together
with botocore, boto3 and boto dependent libraries.

The AWC CLI utilities were also installed.
        
If updates have been made to the github deployment repository
apply the following command:

    git pull
    
The github repository is found at:

    https://github.com/transparenthealth/cdex-deploy/


## Updating the VPC environment

The vpc.yml script will build a VPC environment based upon parameters supplied. These parameters define the following:

- environment name (vpc_env): staging | prod
- region (aws_region): us-east-1

The staging and prod vpc can be updated with the following
shell scripts:

    deploy_prod_now.sh
    deploy_staging_now.sh
    
The scripts run the same vpc.yml process but supply different 
extra values as environment variables to Ansible.




 
