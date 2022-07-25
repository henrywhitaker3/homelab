#!/bin/bash

echo $(date) - Start healthcheck
curl -m 10 --retry 5 {{ healthchecks.backup }}/start
echo ""

echo $(date) - Mounting backups directory
mount 10.0.0.9:/mnt/user/storage/docker /backups

echo $(date) - Running rsync
rsync -avhH --delete --progress /home/{{ ansible_user }}/data /backups/

echo $(date) - Unmounting backups directory
umount /backups

echo $(date) - Finish healthcheck
curl -m 10 --retry 5 {{ healthchecks.backup }}
echo ""
