FROM ubuntu:22.04

ARG USER=abc
ENV HOME=/home/$USER
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

RUN apt-get update && apt-get install -y gnupg software-properties-common wget

RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list

RUN apt-get update

RUN apt-get update && apt-get install -y python3 \
            python3-pip \
            terraform \
            curl \
            openssh-client \
            rsync \
            kbd

RUN sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

RUN adduser --home $HOME --shell /bin/bash --disabled-password --gecos '' $USER

RUN mkdir $HOME/.ssh && \
    chmod 700 $HOME/.ssh && \
    chown $USER:$USER $HOME/.ssh

USER $USER

RUN pip3 install ansible ansible-lint
ENV PATH="/home/abc/.local/bin:$PATH"
ENV ANSIBLE_VAULT_PASSWORD_FILE=~/.vault_pass.txt

WORKDIR $HOME
