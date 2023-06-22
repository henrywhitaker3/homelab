#!/bin/bash

for secret in argo/bootstrap/*.sops.yaml; do
    sops --decrypt $secret | kubectl apply -f -
done
