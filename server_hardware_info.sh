# #! /bin/bash

# server_monitoring_interval=2 
# cpu_thresold=90 
# RAM_thresold=90

server_hardware_info(){

## server hostname
server_hostname=$(hostname)
echo "server hostname is : $server_hostname"

## Total CPU
CPUs=$(lscpu | awk 'NR == 5 {print $2}')
echo "Total number of CPUs (in core): $CPUs"

## Total RAM
RAM=$(free -h | awk 'NR == 2 {print $2}')
echo "Total size of RAM (in MB/GB): $RAM"

## Total Swap
swap=$(free -h | awk 'NR == 3 {print $2}')
echo "Total size of swap (in MB/GB): $swap"

## Total disk
disk=$(ls /sys/block | grep -E 'sd[a-z]' | wc -l)
echo "Total number of disk attached to server: $disk"

## Disk Name
# disk_name=$(ls /sys/block | grep -E 'sd[a-z]' | awk '{ printf "%s ", $0}' | sed 's/,$//')
disk_name=$(ls /sys/block | grep -E 'sd[a-z]' | awk '{ printf "%s ", $0}' | sed 's/,$//')
disk_name2=$(printf '"%s "' "${disk_name[@]}")
disk_name2=${disk_name2%, }


echo "Name of the disk attached to server: $disk_name2"


for item in $disk_name; do

## Each disk size
disk_size=$(lsblk | grep -w $item | awk '{print $1 "-" $4}') 
echo "size of each disk: $disk_size"

disk_size2=$(printf '"%s "' "${disk_size[@]}")
disk_size2=${disk_name2%, }


## Each Partition size and file system type
partition_size=$(df -hT | sed -n "/\/dev\/${item}[1-9]/p" | awk '{print $1 "-" $2 "-" $3}') 
echo "$Partition_size"

partition_size2=$(printf '"%s "' "${partition_size[@]}")
partition_size2=${partition_size2%, }

done

}

server_hardware_info


csv_file="hardware_info.csv"
header="Hostname,cpu(core),RAM,Swap,Total Disk,Disk-Name,Disk-Size,File System"
data=(

   $server_hostname,$CPUs,$RAM,$swap,$disk,$disk_name2,$disk_size2,$partition_size2
)

echo $data

server_hardware_report(){

    echo "${header}" > "${csv_file}"
    for row in "${data[@]}"; do
        echo "$row" >> "$csv_file"

        done

    echo "server hardware information report ${csv_file} is created successfully"
}
server_hardware_report
