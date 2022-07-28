FROM alpine

ARG USER=abc
ENV HOME=/home/$USER

RUN apk add ansible \
            terraform

RUN adduser -D $USER

USER $USER
WORKDIR $HOME
