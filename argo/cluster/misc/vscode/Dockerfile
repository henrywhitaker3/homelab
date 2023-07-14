FROM codercom/code-server:4.14.1

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
                            age

RUN sudo sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin

ENV PATH="/home/coder/.local/bin:$PATH"
RUN pip3 install ansible ansible-lint
