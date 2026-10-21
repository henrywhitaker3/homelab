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
    plex-exporter
    transmission
    orbit
    shelfmark
)

scale() {
    local values_file="kubernetes/mango/apps/media/$1/chart/values.yaml"
    local expression="s/replicaCount: [0-9]+/replicaCount: $2/g"

    if [[ "$OSTYPE" == darwin* ]]; then
        sed -E -i '' "$expression" "$values_file"
    else
        sed -E -i "$expression" "$values_file"
    fi
}

for service in "${media[@]}"; do
    if [ "$1" == "up" ]; then
        scale "$service" 1
    elif [ "$1" == "down" ]; then
        scale "$service" 0
    else
        help
        exit 1
    fi
done
