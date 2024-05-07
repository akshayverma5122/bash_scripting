#! /bin/bash
source_directory="/var/log/"
destination_directory="/tmp"

echo "Enter the directory location which needs to be backed up:"
read source_directory
echo "Enter the directory location where backup need to store in compressed format"
read destination_directory

error_log="/tmp/backup.log"

perform_backup(){

    backup_file="$destination_directory/backup_$(date +%Y%m%d).tar.gz"
    tar czf "$backup_file" "$source_directory"  2>> "$error_log"  
}

echo "starting the backup process"
perform_backup
echo "backup process completed sucessfully"