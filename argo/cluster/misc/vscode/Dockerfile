FROM codercom/code-server:4.16.1

ARG SOPS_VERSION=3.7.3


RUN sudo apt-get update && \
    sudo apt-get install -y vim \
                            gnupg \
                            software-properties-common \
                            apt-transport-https \
                            wget \
                            git \
                            python3 \
                            python3-pip \
                            curl \
                            openssh-client \
                            rsync \
                            age

RUN curl -O https://dl.google.com/go/go1.20.6.linux-amd64.tar.gz && \
    sudo tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz

RUN sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN sudo wget https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -O /usr/local/bin/sops \
    && sudo chmod 0755 /usr/local/bin/sops \
    && sudo chown root:root /usr/local/bin/sops

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && sudo mv kubectl /usr/local/bin/kubectl \
    && sudo chmod +x /usr/local/bin/kubectl

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash

ENV PATH="/usr/local/go/bin:/home/coder/.local/bin:$PATH"
RUN pip3 install ansible ansible-lint
