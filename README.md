# 1ClickECK-Docker-Client

1ClickECK-Docker-Client is used in conjunction with `https://github.com/sunileman/1ClickECK` to deploy the 1ClickECK client. The objective is to make it easy to use 1ClickECK without the worry or effort of building a client node.

## Getting Started
* Have Docker installed on your machine
* Clone `https://github.com/sunileman/1ClickECK`

**Note**
The automation uses Terraform, which relies on state management. Using the Docker file system alone will not provide the state capabilities required to run the tool. Therefore, during Docker runtime, mounting the local volume with the 1ClickECK Git repo is required. This will allow users to leave the Docker instance without losing deployment state.

## Deployment
`docker run -it -v /<PATH-TO-YOUR-LOCAL-1CLICKECK-REPO>/1ClickECK:/1ClickECK 1ClickClient /bin/bash`

## Configure Cloud Access
These configuration are run inside the docker container.

### AWS
* Run `aws configure`

### Azure
* Set up Azure service principal
    * [Create a service principal](https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure?tabs=bash#create-a-service-principal)
    * Make note of the `appId`, `display_name`, `password`, and `tenantID`
    * Set the following environment variables
    ```
    export ARM_CLIENT_ID="Your appID"
    export ARM_CLIENT_SECRET="Your app secret"
    export ARM_SUBSCRIPTION_ID="Your Azure SUBSCRIPTION"
    export ARM_TENANT_ID="Your tenantID"
    export TF_VAR_aks_service_principal_app_id="Your appID"
    export TF_VAR_aks_service_principal_client_secret="Your app secret"
    ```
* Configure Azure CLI
    * Run `az login` with your credentials
    * `az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID`

### GCP
* Run `gcloud init` to initialize your client
* Note: The project must be set in `terraform.tfvars`. The project value within the `tags` variable is used to tag instances with the project value. This is not the same as the GCP project, which is set in `terraform.tfvars`.

## How to run 1ClickECK
Visit [`https://github.com/sunileman/1ClickECK#deployment`](https://github.com/sunileman/1ClickECK#deployment) for instructions.

`Note` -  Since the 1clickeck-client requires mounting a local volume (1ClickECK repo), ll files (ie `terraform.tfvars`) can be modified either from your local host or within the docker conatiner.
