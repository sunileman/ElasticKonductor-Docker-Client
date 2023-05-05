# 1ClickECK-Docker-Client

1ClickECK-Docker-Client is used to in conjuction with `https://github.com/sunileman/1ClickECK` to deploy 1ClickECK client.  Object is to make it easy to to use 1CliCKECK without the worry or effort to build a client node

## Getting Started
* Docker installed on machine
* Clone `https://github.com/sunileman/1ClickECK`

``Note``
The automation uses terraform which relies on state.  Using the docker file system alone will not provide the state capablies required to run the tool.  Therefore during docker run time, mounting the local volume with 1ClickECK git repo is required.  This will allow users to leave docker instance without losing deployment state.

## Deployment
`docker run -it -v /<PATH-TO-YOUR-LOCAL-1CLICKECK-REPO./1ClickECK:/1ClickECK 1ClickClient /bin/bash`

## Configure Cloud Access
`AWS`
* aws configure

`Azure`
* Azure service principal
    * https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal
    * Make note of the `appId`, `display_name`, `password`, and `tenantID`
    * Set the following env variables
    ```
    export ARM_CLIENT_ID="Your appID"
    export ARM_CLIENT_SECRET="Your app secret"
    export ARM_SUBSCRIPTION_ID="Your Azure SUBSCRIPTION"
    export ARM_TENANT_ID="Your tenantID"
    export TF_VAR_aks_service_principal_app_id="Your appID"
    export TF_VAR_aks_service_principal_client_secret="Your app secret"
    ```
* Configure AZ CLI
    * run az login with your creds
    * `az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID`

* `GCP`
    * run gcloud init to initialize your client
    * Note - project must be set in terraform.tfvars.  Project value within tags variable is used to tag instances with project value.  Not the same as gcp project which is set in terrform.tfvars.


## How to run 1ClickECK
`https://github.com/sunileman/1ClickECK#deployment`
