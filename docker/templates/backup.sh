#!/bin/bash

echo $(date) - Mounting backups directory
mount 10.0.0.9:/mnt/user/storage/docker /backups

echo $(date) - Running rsync
rsync -avhH --delete --progress /home/{{ ansible_user }}/data /backups/

echo $(date) - Unmounting backups directory
umount /backups
