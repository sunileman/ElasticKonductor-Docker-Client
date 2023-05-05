# Use the latest Ubuntu image as the base
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
# Install python
################################
RUN apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev


ENV HOME="/root"
WORKDIR ${HOME}
RUN apt-get install -y git
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git .pyenv
ENV PYENV_ROOT="${HOME}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:${PATH}"

ENV PYTHON_VERSION=3.8.13
RUN pyenv install ${PYTHON_VERSION}
RUN pyenv global ${PYTHON_VERSION}
RUN pip install python-hcl2
RUN pip install boto3


################################
# Install AWS CLI
################################

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip && ./aws/install

# add aws cli location to path
ENV PATH=~/.local/bin:$PATH

RUN mkdir ~/.aws && touch ~/.aws/credentials

################################
# Install kubectl
################################
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin


WORKDIR /1ClickECK

