#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo Must provide share to monitor
    exit 1
fi

share=$1

ls "$1" &> /dev/null

success=$?

if [[ $success -eq 0 ]]; then
	echo Share mounted exiting
else
	umount "$1"
	mount "$1"
fi
