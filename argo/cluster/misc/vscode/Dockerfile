FROM codercom/code-server:4.14.1

ARG SOPS_VERSION=3.7.3

RUN sudo apt-get update && \
    sudo apt-get install -y vim \
                            gnupg \
                            software-properties-common \
                            wget \
                            git \
                            python3 \
                            python3-pip \
                            curl \
                            openssh-client \
                            rsync \
                            age \
                            golang-go

RUN sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN sudo wget https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -O /usr/local/bin/sops \
    && sudo chmod 0755 /usr/local/bin/sops \
    && sudo chown root:root /usr/local/bin/sops

ENV PATH="/home/coder/.local/bin:$PATH"
RUN pip3 install ansible ansible-lint
