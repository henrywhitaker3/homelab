#!/bin/bash

if [[ $# -ne 2 ]]; then
    echo "Usage: port-check.sh <host> <port>"
    exit 1
fi

host=$1
port=$2

status="ERROR"
if nc -z -w 5 "$host" "$port"; then
    status="OK"
fi

echo "$(date) - [$status] - checking $host:$port"
