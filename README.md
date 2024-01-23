# ElasticKonductor-Docker-Client

ElasticKonductor-Docker-Client is used in conjunction with `https://github.com/sunileman/ElasticKonductor` to deploy the ElasticKonductor client. The objective is to make it easy to use ElasticKonductor without the worry or effort of building a client node.

## Architecture
![2024-01-23_16-02-56](https://github.com/sunileman/ElasticKonductor-Docker-Client/assets/12245219/f48d554c-60c4-4f5d-8962-2e6bf7cd528c)

## Getting Started
* Have Docker installed on your machine
* Clone `https://github.com/sunileman/ElasticKonductor`

**Note**
The automation uses Terraform, which relies on state management. Using the Docker file system alone will not provide the state capabilities required to run the tool. Therefore, during Docker runtime, mounting the local volume with the ElasticKonductor Git repo is required. This will allow users to leave the Docker instance without losing deployment state.

## Deployment
`docker run -it -v /<PATH-TO-YOUR-LOCAL-ElasticKonductor-REPO>/ElasticKonductor:/ElasticKonductor sunmanreg.azurecr.io/elastickondoctor-client:latest /bin/bash`

## Configure Cloud Access
These configuration are run inside the docker container and needs to be run **EACH** time you enter the conatiner.

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
* https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#gcloud
* run `gcloud init` to initialize your client
* run `gcloud auth application-default login --no-launch-browser`
* Note - gcp project must be set in `terraform.tfvars` or set as an env variable `export TF_VAR_gcp_project="your-project-name"`.  
* Project value within `terraform.tfvars` tags variable is used to tag instances with project value. This is different from the gcp project you are assigned to. 

## How to run ElasticKonductor
Visit [`https://github.com/sunileman/ElasticKonductor#deployment`](https://github.com/sunileman/ElasticKonductor#deployment) for instructions.

`Note`: The automation requires `tags.project` variable to be set in the `.[aws|azure]/terraform.tfvars`.  Set the variable with your username, no special characters. Keep it short

#### Required Arguments 

`-c` [aws|azure|gcp|ess]

`-b` [all|k8s|otel] 

`-d` Destroy all assets created by the automation

`-r` disable openebs

`de` destroy ECK

`do` destroy Open Telemetry

`i` get cluster info 

`int` get cluster infra info 

`Note` -  Since the ElasticKonductor-client requires mounting a local volume (ElasticKonductor repo), ll files (ie `terraform.tfvars`) can be modified either from your local host or within the docker conatiner.



### KUBECTL
The Docker image comes with a pre-installed version of `kubectl`, however, it may not be compatible with the version of Kubernetes deployed with `ElasticKonductor`. To resolve this issue, you can rebuild the image by modifying the `ENV KUBECTL_VERSION` environment variable within the Docker file to specify the preferred version of kubectl

For example to build a image with version `1.24.0`
`docker build --build-arg KUBECTL_VERSION=1.24.0 -t ElasticKonductor-client`


### Opentelemetry Demo UI
* run `kubectl get svc open-telemetry-frontendproxy`
* Reach the UI by using `EXTERNAL-IP`:8080




### Errors

Error
`WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested`

Solution
Ignore this message
