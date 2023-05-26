# ElasticKonductor-Docker-Client

ElasticKonductor-Docker-Client is used in conjunction with `https://github.com/sunileman/ElasticKonductor` to deploy the ElasticKonductor client. The objective is to make it easy to use ElasticKonductor without the worry or effort of building a client node.

## Architecture
[![1-Click-Page-1-4.png](https://i.postimg.cc/tgWWmhvt/1-Click-Page-1-4.png)](https://postimg.cc/d7QhhTYL)

## Getting Started
* Have Docker installed on your machine
* Clone `https://github.com/sunileman/ElasticKonductor`
* Pull image `docker pull sunmanreg.azurecr.io/elastickondoctor-client:latest` and then tag the image `docker tag sunmanreg.azurecr.io/elastickondoctor-client:latest elastickondoctor-client:latest`

**Note**
The automation uses Terraform, which relies on state management. Using the Docker file system alone will not provide the state capabilities required to run the tool. Therefore, during Docker runtime, mounting the local volume with the ElasticKonductor Git repo is required. This will allow users to leave the Docker instance without losing deployment state.

## Deployment
`docker run -it -v /<PATH-TO-YOUR-LOCAL-ElasticKonductor-REPO>/ElasticKonductor:/ElasticKonductor elastickondoctor-client /bin/bash`

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
* https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl#gcloud
* run `gcloud init` to initialize your client
* run `gcloud auth application-default login --no-launch-browser`
* Note - gcp project must be set in `terraform.tfvars` or set as an env variable `export TF_VAR_gcp_project="your-project-name"`.  
* Project value within `terraform.tfvars` tags variable is used to tag instances with project value. This is different from the gcp project you are assigned to. 

## How to run ElasticKonductor
Visit [`https://github.com/sunileman/ElasticKonductor#deployment`](https://github.com/sunileman/ElasticKonductor#deployment) for instructions.

`Note` -  Since the ElasticKonductor-client requires mounting a local volume (ElasticKonductor repo), ll files (ie `terraform.tfvars`) can be modified either from your local host or within the docker conatiner.



### KUBECTL
The Docker image comes with a pre-installed version of `kubectl`, however, it may not be compatible with the version of Kubernetes deployed with `ElasticKonductor`. To resolve this issue, you can rebuild the image by modifying the `ENV KUBECTL_VERSION` environment variable within the Docker file to specify the preferred version of kubectl

For example to build a image with version `1.24.0`
`docker build --build-arg KUBECTL_VERSION=1.24.0 -t ElasticKonductor-client`


### Opentelemetry Demo Port Forwarding
Since ElasticKonductor client runs within a docker container, port forwarding should occur from the local machine you want to reach the Demo UI.  To do this, the steps are simple.  Run the following steps on `YOUR LOCAL HOST/MACHINE`, not within your docker instance

* Verify azure CLI is install on your local machine
    * `az aks install-cli`
* Install `kubectl`
    * `https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos`
    * ie for mac: `brew install kubectl`
* Fetch the resource group and cluster name.  Run this within the docker client
    * `./elastickonductor.sh -c azure -inf`
    * The output will look similar to this
    ```
    K8s Cluster Name: 1ClickECK-sunman-midge
    K8s Region: eastus
    Resource group name: "1ClickECK-sunman-midge" 
    ```
* Set your local kubectl by using the output from the previous step
    * `az aks get-credentials --resource-group <resource group name> --name <cluster name>`
* Expose the frontendproxy service
    * `kubectl port-forward svc/open-telemetry-frontendproxy 8080:8080`
* To generater spans from the browser to be properly collected
    * `kubectl port-forward svc/open-telemetry-otelcol 4318:4318`




### Errors

Error
`WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested`

Solution
Ignore this message