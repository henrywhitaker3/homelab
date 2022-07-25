#!/bin/bash

echo Start healthcheck
date
curl -m 10 --retry 5 {{ healthchecks.backup }}/start
echo ""


echo Mounting backups directory
date
mount 10.0.0.9:/mnt/user/storage/docker /backups

echo Running rsync
date
rsync -avhH --delete --progress /home/{{ ansible_user }}/data /backups/

echo Unmounting backups directory
date
umount /backups

echo Finish healthcheck
date
curl -m 10 --retry 5 {{ healthchecks.backup }}
