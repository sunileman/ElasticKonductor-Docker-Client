# Use the latest Ubuntu image as the base
##version 1.3
FROM amd64/ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

RUN \
# Update
apt-get update -y && \
# Install Unzip
apt-get install unzip -y && \
# need wget
apt-get install wget -y && \
# vim
apt-get install vim curl git -y


################################
# Install Terraform
################################

# Download terraform for linux
RUN wget https://releases.hashicorp.com/terraform/1.4.6/terraform_1.4.6_linux_amd64.zip

# Unzip
RUN unzip terraform_1.4.6_linux_amd64.zip

# Move to local bin
RUN mv terraform /usr/local/bin/
# Check that it's installed
RUN terraform --version 


################################
# Install AWS CLI
################################

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && ./aws/install

# add aws cli location to path
ENV PATH=~/.local/bin:$PATH

RUN mkdir ~/.aws && touch ~/.aws/credentials

################################
# Install Azure CLI
################################

# Azure installation command
RUN	curl -sL https://aka.ms/InstallAzureCLIDeb | bash

################################
# Install GCP CLI
################################

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |  tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install google-cloud-cli
RUN apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

################################
# Install kubectl
################################
#https://kubernetes.io/releases/
ENV KUBECTL_VERSION 1.26.4
RUN curl -LO https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin



################################
# Install python
################################
ENV PYTHON_VERSION 3.8.13

#Set of all dependencies needed for pyenv to work on Ubuntu
RUN apt-get update \ 
        && apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 git

# Set-up necessary Env vars for PyEnv
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

# Install pyenv
RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

RUN pip install python-hcl2 boto3


################################
# Install Helm
################################
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | tee /usr/share/keyrings/helm.gpg > /dev/null && \
apt-get install apt-transport-https --yes && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list && \
apt-get update && \
apt-get install helm


WORKDIR /ElasticKonductor

