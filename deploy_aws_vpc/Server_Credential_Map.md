# Server Credential Map 

Author: mark
Created: 2019-09-25.12:43

Repository: https://github.com/TransparentHealth/cdex-deploy

## Introduction

The Share My Health Platform consists of four connected systems.

1. Verify My Identity Open ID Connect (id) server
2. Share My Health OAuth 2.0 Hub Server (Hub)
3. Client App Server (App) 
4. HIE/FHIR Resource Server (data)

The servers are connected via OAuth2.0 tokens. The Resource Provider, 
the originator of the OAuth2.0 token will retain the credentials for a
requestor server in their database.

The requestor will typically store the issued credentials in environment 
variables used to configure the requestor server.

The data stored by a requestor server includes:

- Server URI
- OAuth2.0 Key
- OAuth2.0 Secret

Depending on the server role multiple sets of credentials may need to be 
generated and installed on requestor servers. We have therefore established
a convention for naming the OAuth2.0 Key.

The convention is as follows:

{Requestor_Server_Name}{.optional_random_string} @ {Resource_Provider_Server_Name}
 
for example:

hub.stage.sharemy.health.5317@id.stage.sharemy.health

The optional random string enables multiple credentials to be issued to a server to support activities such as credential rotation.


## Credential Mapping

### APP server

**Environment Variables:**

Connection to HUB Server:
- app.stage.sharemy.health.1010@hub.stage.sharemy.health

Connection to ID Server:
- app.stage.sharemy.health.1011@id.stage.sharemy.health

**Database Entry:**

None

### HUB server

**Environment Variables:**

Connection to ID Server:
- hub.stage.sharemy.health.2020@id.stage.sharemy.health

**Database Entry:**

Connection from APP Server:
- app.stage.sharemy.health.1010@hub.stage.sharemy.health


### ID server

**Environment Variables:**

None

**Database Entry:**

Connection from HUB Server:
- hub.stage.sharemy.health.2020@id.stage.sharemy.health

Connection from APP Server:
- hub.stage.sharemy.health.2020@id.stage.sharemy.health


## Configuring Credentials

Credentials are passed into the respective applications using Environment Variables that are loaded 
via the EC2 ParameterStore or via a .env settings file.

The ENVIRONMENT VARIABLE or EC2 ParameterStore entry should be an uppercase string that matches the 
django settings value.

The Environment Variables are written to a .env file via an ansible template. the Ansible variable
will be a lower case match to the ENVIRONMENT VARIABLE name with a prefix that indicates which 
variable or vault file it is referenced in. For example:

In the staging environment:

Django Settings name = MY_CUSTOM_NAME
Environment Variable = MY_CUSTOM_NAME
Ansible Common Vars file = my_custom_name
Ansible app Vars file = app_my_custom_name
Ansible app Vault file = vault_app_my_custom_name

In ansible a variable can reference another variable by wrapping the name in {{ }}.

Therefore an ansible template can refer to:

export MY_CUSTOM_NAME='{{ my_custom_name }}'

where common.yml has:

my_custom_name: "{{ app_my_custom_name }}"

where the app specific vars file can have:

app_my_custom_name: "{{ vault_app_my_custom_name }}"

where the encrypted app vault file has:

vault_app_my_custom_name: "a secret I am not going to reveal to you"


