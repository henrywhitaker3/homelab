#!/bin/bash

help() {
    echo "Usage: [up|down]"
}

if [ $# -ne 1 ]; then
    help
    exit 1
fi

media=(
sonarr
radarr
plex
transmission
)

scale() {
    sed -E -i "s/replicaCount: [0-9]+/replicaCount: $2/g" "kubernetes/k3s/apps/media/$1/chart/values.yaml"
}

for service in ${media[@]}; do
    if [ $1 == "up" ]; then
        scale $service 1
    elif [ $1 == "down" ]; then
        scale $service 0
    else
        help
        exit 1
    fi
done
