# Alliance For Better Health - Share My Health
System handover documentation:
	- Open Source Software Repositories
	- Software Update methods
	- Scripted Variables
	- Keys 

## Open Source Repositories for ShareMyHealth 

### Verify My Identity

Provides identity management services for users and Community Based Organization agents.

[GitHub - TransparentHealth/vmi: Verify My Identity is an OpenID Connect (OIDC) Provider in Django (Python)](https://github.com/TransparentHealth/vmi)

### ShareMyHealth / OAuth2.0 Provider

Controls access and sharing of information from HIXNY.

[GitHub - TransparentHealth/sharemyhealth: An OAuth2 Provider with a built-in FHIR functionality.](https://github.com/TransparentHealth/sharemyhealth)

### CDA2FHIR-Service

An app that converts HIXNY C-CDA documents to FHIR STU3 Resources.

[GitHub - TransparentHealth/cda2fhir-service: A CDA To FHIR Micro Webservice in Java](https://github.com/TransparentHealth/cda2fhir-service)

### ShareMyHealth App

A Health Record viewing app for users and CBO agents.

[GitHub - TransparentHealth/smh_app: Share My Health App: An application for Community Members and Community Based Organizations](https://github.com/TransparentHealth/smh_app)

### CDEX Deploy

Deployment scripts to update Share My Health Servers.

[GitHub - TransparentHealth/cdex-deploy: Deployment Information for Consumer-Directed Health Exchange (CDEX). This includes the “vmi”, “sharemyhealth”, and “smh_app” projects](https://github.com/TransparentHealth/cdex-deploy/)

Deployment scripts use Ansible to perform server updates.

## Deployment Processes
There are three environments for the ShareMyHealth platform:
	- Development
	- Staging
	- Production

Each environment operates in its own Virtual Private Cloud.

Three zones exist in each environment:
	- DMZ (For Load Balancers and Management Controller)
	- APP (For the VMI, ShareMyHealth, CDA2FHIR-Service and ShareMyHealth App servers)
	- DB (For access points for the Posatgresql RDS Service)

To update the servers in each environment perform the following steps:

```
export MGMT_DEV=ec2-3-228-2-84.compute-1.amazonaws.com
export MGMT_PROD=ec2-3-219-170-31.compute-1.amazonaws.com
export MGMT_STAGING=ec2-3-219-29-74.compute-1.amazonaws.com
	
```

	- ssh to the management controller in the relevant environment.
	
For example, for the DEV environment:
```
ssh -i ~/.ec2/abhealth/mgmt-controller.pem ubuntu@$MGMT_DEV
```

Once connected to the server:
	- Perform any updates to the management controller:
```
sudo apt-get -y upgrade
# sometimes security patches require the following command:
sudo apt-get -y dist-upgrade
```

	* Setup the environment to perform deployments with the following command:
```
deploy
```

	- Then run the sequence of commands identified by the deploy command:
```
# set necessary environment variables
source ../env/bin/activate
# update deployment scripts from the cdex-deploy repository
git pull
# set the host names and associated variables
source ~/sethosts
# optinally run through all deployments
~/do_all
```

To perform the updates to each server individually use the following command:

For VMI:
```
export  ROLE_TYPE=vmi
export  VARIABLE_HOST=$VMI_HOST
ansible-playbook playbook/server/server_app_configure.yml --vault-password-file ../env/ansibled-$VPC_ENV.vault --extra-vars "vpc_env=$VPC_ENV role_type=$ROLE_TYPE variable_host=$VARIABLE_HOST "
```

For ShareMyHealth:
```
export  ROLE_TYPE=smh
export  VARIABLE_HOST=$SMH_HOST
ansible-playbook playbook/server/server_app_configure.yml --vault-password-file ../env/ansibled-$VPC_ENV.vault --extra-vars "vpc_env=$VPC_ENV role_type=$ROLE_TYPE variable_host=$VARIABLE_HOST "
```

For ShareMyHealth App:
```
export  ROLE_TYPE=smh_app
export  VARIABLE_HOST=$SMH_APP_HOST
ansible-playbook playbook/server/server_app_configure.yml --vault-password-file ../env/ansibled-$VPC_ENV.vault --extra-vars "vpc_env=$VPC_ENV role_type=$ROLE_TYPE variable_host=$VARIABLE_HOST "
```

When a script completes a message is posted to the afbh-updates channel on the TransparentHealth slack.

Updates to the CDA2FHIR-Service are performed automatically as part of the Elastic Beanstalk service.

The Configure script for ShareMyHealth will detect the IP address for the CDA2FHIR-Service and configure the ShareMyHealth Server to connect to the service. If an elastic Beanstalk updates results in the IP address changing for the CDA2FHIR-Service simply run the configure step for ShareMyHealth and it should detect and configure the new server.

The Staging Environments have been configured with Auto Scaling Target Groups.  When the Servers are updated a new AMI is created and added to the Launch Group that is used by the Autoscaling. 
Scaling is not implemented in DEV because it adds significantly to the deployment times. An AMI image can take 10 minutes to create.

In the STAGING  environments after a server update has been run it is necessary to run an additional step. This step sets up the autoscaling with the new server configuration.  This involves creating a new AMI server image and assigning it to a new version of the Autoscaling Group. 

The command to update the autoscaling service is:

```
ansible-playbook playbook/server/server_app_scale.yml --vault-password-file ../env/ansibled-$VPC_ENV.vault --extra-vars "vpc_env=$VPC_ENV vpc_base_region=us-east vpc_number=1 aws_region=us-east-1 role_type=$ROLE_TYPE variable_host=$VARIABLE_HOST  " 
```

The AutoScaling group setup needs to be replicated from STAGING to PROD and then the same server/_app/_scale.yml script can be run to implement autoscaling in PROD. 

If a new server needs to be deployed to replace an existing server  the following commands can be run:
```
export ROLE_TYPE=vmi|smh|smh_app
export 
ansible-playbook  playbook/server/server_app_build.yml --vault-password-file ../env/ansibled-$VPC_ENV.vault --extra-vars "vpc_env=$VPC_ENV role_type=$ROLE_TYPE " 
```

After this script runs it will be necessary to update the ~/sethosts file to replace the internal dns name for the appropriate VMI_HOST, SMH_HOST or SMH_APP_HOST variables.

## Scripted Variables
Settings for each application are stored in the CDEX-deploy repository. Sensitive values are stored in password protected Vault files.

The management server has a text file with the password that is used to unlock the vault files when scripts are run.

## Keys
Public and private keys are used on each of the servers. The  private key needed to access the management servers needs to be installed on the machine used to manage the environment.

The mgmt-controller.pem file and the vault password will be sent in an encrypted zip file. The password will then be sent separately via SMS Text message.

 



---

Author: mark scrimshire @ekivemark
Created: 2020-05-28.09:58

cdex-deploy/system-overview.md

