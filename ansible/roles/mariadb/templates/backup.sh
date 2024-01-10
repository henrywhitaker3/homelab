#!/bin/bash

date=$(date +"%Y_%m_%d_%H_%M_%S")
target="{{ mariadb_backup_directory }}/$date"

mariabackup --backup --target-dir=$target --user=root

cd {{ mariadb_backup_directory }}
tar -czvf $target.tar.gz $date
rm -rf $target

find {{ mariadb_backup_directory }} -mindepth 1 -mtime +{{ mariadb_backup_retention_days }} -delete
