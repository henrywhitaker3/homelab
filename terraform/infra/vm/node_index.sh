#!/bin/bash

help() {
    echo "Usage [total nodes] [index]"
}

if [[ $# -ne 2 ]]; then
    help
    exit 1
fi

count=$1
index=$2

mod=$(( $index % $count ))

if [[ $mod -eq 0 ]]; then
    mod=$count
fi

mod=$(( $mod - 1 ))

echo "{\"index\": \"$mod\"}"
