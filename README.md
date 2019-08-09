# Consumer Directed Exchange (CDEx)

The Alliance for Better Health Consumer Directed Exchange (CDEx) 
platform is designed to enable consumers to access their health 
information from multiple sources and to then share that information 
with the Community-Based Organizations (CBOs) and other services 
that they choose to trust.

The CDEx platform consists of three components:

1. Verify My Identity Platform (VMI)
2. Share My Health (SMH)
3. Fast Healthcare Interoperability Resource (FHIR) health data store

The CDEx platform is a suite of Open Source servers. VMI and SMH are 
built using software provided by Transparent Health.

## VMI

The Verify My Identity (VMI) server is a certified OpenID Connect 
Provider supporting identity assurance escalation and FIDO.

FIDO is a phishing-resistant strong authentication service.

The server enables a consumer to establish a user account that can
be used to authorize access to their health information from 
multiple sources.

Trusted agents acting on behalf of Community-Based Organizations (CBOs)
can perform in-person Identity verification to create a VMI account 
for a consumer. 

## Share My Health (SMH)

The Share My Health (SMH) Server is a Consumer-Mediated Health
Information Exchange. SMH supports multiple trusted connections to 
Application Programming Interfaces and services such as CMS Blue Button
and state-based Health Information Exchanges.

SMH integrates with VMI to enable a consumer to authorize the sharing
of their health information with CBO's and other health services
using their user credentials stored in the VMI server. 

A consumer can use their VMI user account to authorize access from
multiple data sources to CBOs and other service providers that connect
to the SMH server.

The consumer executes their HIPAA right of access to permit the 
sharing of their health information with CBOs and services that are 
connected to SMH and that the consumer has explicitly authorized to 
receive their information.

The consumer may access the SMH server at anytime and, after authenticating
with their VMI credentials, can choose to revoke access to their 
data by any, or all, of the services connected to their health 
information. 

## FHIR Data Store (HAPI)

The FHIR Health-API (HAPI) server enables the storage of health-related information. 
The FHIR server stores information such as Patient, Organization and
Location information in a standardized format based upon resources 
defined as part of the HL7 FHIR STU3 specification. 

# Deploying CDEx

The CDEx platform has been designed for deployment via the Docker
containerization service.

The components involved include:

- PostgreSQL database server using AWS RDS
- Nginx web server
- Python Django Application and framework
- HAPI FHIR JPA Server
- Tomcat Java application server

THe suite of containerized services have been configured to avoid 
conflicts if running on the same server.

PostgreSQL is configured to run on port 5432
HAPI FHIR is configured to run on port 8080
SMH is configured to run on port 8001
VMI is configured to run on port 8000

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

The deployment scripts will be installed on a Management Server in the
main AWS account. The requirements to run Ansible and the deployment 
scripts will be installed and this machine will be used for all 
deployments. This will eliminate inconsistencies in the deployment 
environment.

The environment manager will connect to the Management Server via SSH
and will run necessary scripts from the server.




 
