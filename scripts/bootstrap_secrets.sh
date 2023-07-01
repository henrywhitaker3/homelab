#!/bin/bash

for secret in argo/bootstrap/sops/*.sops.yaml; do
    sops --decrypt $secret | kubectl apply -f -
done
