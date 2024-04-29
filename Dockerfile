FROM ubuntu:22.04
# renovate: datasource=github-releases depName=getsops/sops
ARG SOPS_VERSION=v3.7.3
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize
ARG KUSTOMIZE_VERSION="v5.4.1"
# renovate: datasource=github-releases depName=homeport/dyff
ARG DYFF_VERSION="1.7.1"


ARG USER=abc

ENV HOME=/home/$USER
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y gnupg software-properties-common wget git

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update

RUN apt-get update && apt-get install -y python3 \
            python3-pip \
            terraform \
            curl \
            openssh-client \
            rsync \
            kbd \
            age \
            jq

RUN wget https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux.amd64 -O /usr/local/bin/sops \
    && chmod 0755 /usr/local/bin/sops \
    && chown root:root /usr/local/bin/sops

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && mv kubectl /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl

RUN wget https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz \
    && chmod +x kustomize \
    && mv kustomize /usr/local/bin

RUN wget https://github.com/homeport/dyff/releases/download/v${DYFF_VERSION}/dyff_${DYFF_VERSION}_linux_amd64.tar.gz \
    && tar -xzvf dyff_${DYFF_VERSION}_linux_amd64.tar.gz \
    && mv dyff /usr/local/bin

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

RUN adduser --home $HOME --shell /bin/bash --disabled-password --gecos '' $USER

RUN mkdir $HOME/.ssh && \
    chmod 700 $HOME/.ssh && \
    chown $USER:$USER $HOME/.ssh

USER $USER

RUN pip3 install ansible ansible-lint
ENV PATH="/home/abc/.local/bin:$PATH"

WORKDIR $HOME
