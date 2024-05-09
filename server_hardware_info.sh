# #! /bin/bash

## Defining the function

server_hardware_info(){

## server hostname
server_hostname=$(hostname)
# echo "server hostname is : $server_hostname"

## Total CPU
CPUs=$(lscpu | awk 'NR == 5 {print $2}')
# echo "Total number of CPUs (in core): $CPUs"

## Total RAM
RAM=$(free -h | awk 'NR == 2 {print $2}')
# echo "Total size of RAM (in MB/GB): $RAM"

## Total Swap
swap=$(free -h | awk 'NR == 3 {print $2}')
# echo "Total size of swap (in MB/GB): $swap"

## Total disk
disk=$(ls /sys/block | grep -E 'sd[a-z]' | wc -l)
# echo "Total number of disk attached to server: $disk"

## Disk Name
# disk_name=$(ls /sys/block | grep -E 'sd[a-z]' | awk '{ printf "%s ", $0}' | sed 's/,$//')
disk_name=$(ls /sys/block | grep -E 'sd[a-z]' | awk '{ printf "%s ", $0}' | sed 's/,$//')
## formatting the output of disk_name variable
disk_name2=$(printf '"%s "' "${disk_name[@]}")
disk_name2=${disk_name2%, }
# echo "Name of the disk attached to server: $disk_name2"


for item in $disk_name; do

## Each disk size
disk_size=$(lsblk | grep -w $item | awk '{print $1 "-" $4}') 
# echo "size of each disk: $disk_size"
## formatting the output of disk_size variable
disk_size2=$(printf '"%s "' "${disk_size[@]}")
disk_size2=${disk_name2%, }


## Each Partition size and file system type
partition_size=$(df -hT | sed -n "/\/dev\/${item}[1-9]/p" | awk '{print $1 "-" $2 "-" $3}') 
# echo "$Partition_size"

## formatting the output of partition_size variable
partition_size2=$(printf '"%s "' "${partition_size[@]}")
partition_size2=${partition_size2%, }

done

}

## calling the function

server_hardware_info

########### appending the server hardware information in the csv file ###################################

## Name of the csv file
csv_file="hardware_info.csv"


## csv file header
header="Hostname,cpu(core),RAM,Swap,Total Disk,Disk-Name,Disk-Size,File System"

## data which need to append in the csv file
data=(

   $server_hostname,$CPUs,$RAM,$swap,$disk,$disk_name2,$disk_size2,$partition_size2
)

# echo $data

## Defining the function

server_hardware_report(){

    echo "${header}" > "${csv_file}"
    for row in "${data[@]}"; do
        echo "$row" >> "$csv_file"

        done

    echo "server hardware information report ${csv_file} is created successfully"
}

## calling the function
server_hardware_report
