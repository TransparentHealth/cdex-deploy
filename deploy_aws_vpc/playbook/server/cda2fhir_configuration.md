# CDA2FHIR Service on ElasticBeanstalk

Author: mark
Created: 2019-11-12.10:10

cdex-deploy

# Alliance For Better Health - CDA2FHIR
## Environments
Development = dev
Staging = staging
Production = prod

These will be represented as {env} in this guide.

### App zone Subnets
The CDA2FHIR service will be installed in the App zone

- Development
	- 10.12.4.0
	- 10.12.5.0
	- 10.12.6.0
- Staging
	- 10.13.4.0
	- 10.13.5.0
	- 10.13.6.0
- Production
	- 10.14.4.0
	- 10.14.5.0
	- 10.14.6.0

### DMZ Subnets
The Management server is installed in the DMZ zone and ssh is used to control servers.

- Development
	- 10.12.1.0
	- 10.12.2.0
	- 10.12.3.0
- Staging
	- 10.13.1.0
	- 10.13.2.0
	- 10.13.3.0
- Production
	- 10.14.1.0
	- 10.14.2.0
	- 10.14.3.0


## Setup Security Groups
Name: {env}_cda_APP
	- dev_cda_APP
	- staging_cda_APP
	- prod_cda_APP


### Inbound Rules
- dev:
	- Custom TCP Rule  8080  10.12.4.0/24
	- Custom TCP Rule  8080  10.12.5.0/24
	- Custom TCP Rule  8080  10.12.6.0/24
	- SSH 22 10.12.1.0/24
	- SSH 22 10.12.2.0/24
	- SSH 22 10.12.3.0/24

- staging:
	- Custom TCP Rule  8080  10.13.4.0/24
	- Custom TCP Rule  8080  10.13.5.0/24
	- Custom TCP Rule  8080  10.13.6.0/24
	- SSH 22 10.13.1.0/24
	- SSH 22 10.13.2.0/24
	- SSH 22 10.13.3.0/24

- prod:
	- Custom TCP Rule  8080  10.14.4.0/24
	- Custom TCP Rule  8080  10.14.5.0/24
	- Custom TCP Rule  8080  10.14.6.0/24
	- SSH 22 10.14.1.0/24
	- SSH 22 10.14.2.0/24
	- SSH 22 10.14.3.0/24

## ElasticBeanstalk Settings
### Security
	- EC2 key pair: abhealth-dev-servers
### Network
	- VPC
		- ABH-{env}-A
	- Subnets:
		- {env}-app-a
		- {env}-app-b
		-  {env}-app-c
	- Public IP
		- Disabled

# IMPORTANT:

Tag the Elastic Beanstalk VM Instance with the following tags:
      function: "cda2fhir"
      role: "cda"
      workflow: "service"
 
This will allow the deployment scripts to discover the 
ip address of the VM running the CDA2FHIR Service.

