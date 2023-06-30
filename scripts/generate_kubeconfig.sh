#!/bin/bash

if [ $# -ne 1 ]; then
    echo Provie svcacct name
    exit 1
fi

name="$1"

# your server name goes here
server=https://10.0.0.6:6443
# the name of the secret containing the service account token goes here
secret="$name-token"

ca=$(kubectl get secret $secret -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret $secret -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret $secret -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: k3s
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: k3s
    namespace: default
    user: $name
current-context: default-context
users:
- name: $name
  user:
    token: ${token}
" > /tmp/$name.kubeconfig

