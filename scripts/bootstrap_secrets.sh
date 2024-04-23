#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Provide a cluster context name first"
fi

for secret in "kubernetes/$1/bootstrap/sops/*.sops.yaml"; do
    sops --decrypt $secret | kubectl apply -f -
done
