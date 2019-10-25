# Consumer Directed Exchange (CDEx)

The Alliance for Better Health Consumer Directed Exchange (CDEx) 
platform is designed to enable consumers to access their health 
information from multiple sources and to then share that information 
with the Community-Based Organizations (CBOs) and other services 
that they choose to trust.

The CDEx platform consists of multiple loosely coupled components:

1. Verify My Identity (VMI) `vmi`: An OpenID Connect Identity provider to provider single signon.
2. Share My Health (SMH) `sharemyhealth` : OAuth2 Provider / FHIR Server / FHIR Proxy `sharemyhealth`. 
If configured to do so, it communicates with a health information exchange to receive CDA content then
converts the CDA content into FHIR content, and make it avaaible as a FHIR API. This function relies on #4.
3. Share My Health App (SMH_APP) `smh_app` - An organization agent and member facing application for sharing health information `smh_app`
4. CDA2FHIR Webservice - A tool for converting CDA to FHIR v3. We use it to convert a CCDA to a Patient Bundle within #2.
5. 3rd Party FHIR services including your own. Examples include HAPI FHIR and Microsoft Azure FHIR. 
These services could connect at either #2 or #3. If customizing these tools for your own purposes, you might consider 
adding a custom app to #2, Share My Health (SMH) OAuth2 Provider.


The CDEx platform is a suite of open source software. 
Projects are managed @ Transparent Health.

https://github.com/TransparentHealth


# Deploying CDEx

The possiblitiesCDEx platform was designed for deployment via Ansible. 

The components involved include:

- PostgreSQL database server (using AWS RDS)
- Nginx web server / Gunicorn
- Python Django Application and framework
- HAPI FHIR JPA Server
- Tomcat Java application server for CDA2FHIR Service

Containerized services should be configured to avoid 
conflicts if running on the same server.

* PostgreSQL is configured to run on port 5432
* HAPI FHIR is configured to run on port 8080
* VMI is configured to run on port 8000
* SMH is configured to run on port 8001
* SMH_APPis configured to run on port 8002
* CDA2FHIR is configured to run on port 8081 (internal)


SMY, VMI and FHIR all use PostgreSQL as a database service via
port 5432. In STAGING and PRODUCTION these database services are
provided by AWS RDS.

The deployment instructions for each service can be found in the
respective README.md file.

- HAPI FHIR: https://github.com/TransparentHealth/THAPI/blob/master/README.md
- VMI: https://github.com/TransparentHealth/vmi/blob/master/README.md
- SMH: https://github.com/TransparentHealth/sharemyhealth/blob/master/README.md

Deployment is performed using Ansible Scripts. Scripts are provided for:

- Creating a 4 area VPC across 3 availability Zones
- Creating Security Groups for Inter-area communication
- Deploying Launch configurations with auto scaling groups that can be attached to a Load Balancer via Target Groups.

The following systems will be configured manually. Their configuration will be documented via a README.md file in this repository:

- Application Load Balancers
- AWS RDS PostgreSQL database
- Security Groups
- Peering configurations

The deployment scripts should be installed on a Management Server in the
main AWS account. The requirements to run Ansible and the deployment 
scripts should be installed and this machine will be used for all 
deployments. This eliminates inconsistencies in the deployment 
environment.

The environment manager connects to the Management Server via SSH
and runs necessary scripts from the server.


## Resources:

Setup Ansible control node:
https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04

Install Docker: 
https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-docker-on-ubuntu-18-04


Install Ansible:


    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible

 
