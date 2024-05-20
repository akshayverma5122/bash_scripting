#! /bin/bash 

## Defining the thresold

RAM_Thresold=90
CPU_Thresold=90
Disk_Thresold=80
Interval=5

## Total hardware resource

server_monitoring(){

  while true; do

  clear
  echo "Monitor the server in $Interval"

  echo 

## Display CPU utilization 

echo "Server CPU Utilization"
echo
top -bn1 | grep '%Cpu' | sed 's/,/\n/g'
echo

## Display disk utilization

echo "Server disk Utilization"\n

echo
df -h | grep -E 'sd[a-z]' | awk '{print $1 " " $5 }'

echo

## Display RAM & Swap utilization

echo "Server Memory Utilization"
echo

free -h 


    check_critical_metrics
    sleep "${Interval}"
    done


}


check_critical_metrics(){

  echo 

filesystem=$(df -h | grep -E 'sd[a-z]' | awk '{print $1}')

for filesystem in $filesystem; do

filesystem_utilization=$( df $filesystem | awk 'NR == 2 {print $5}' | sed 's/%//')

# echo "${filesystem_utilization}"

if  (( filesystem_utilization >= Disk_Thresold  )) ; then

echo "utilization of file system $filesystem is high"

else  

echo "utilization of file system $filesystem is normal"

fi



done


# cpu usage per user

    cpu_usage=$(top -bn1 | grep '%Cpu' | awk '{print $2}' | cut -d '.' -f1)

# calculating RAM utilization in percentage

    total_ram=$(free | awk '/^Mem:/ {print $2}')

    used_ram=$(free | awk '/^Mem:/ {print $3}')
    used_ram_in_percentage=$(echo "scale=2; ($used_ram / $total_ram) * 100" | bc)
    
    available_ram=$(free | awk '/^Mem:/ {print $7}')
    available_ram_in_percentage=$(echo "scale=2; ($available_ram / $total_ram) * 100" | bc)
    
# comparing with thresold 

  if ((  $( echo "$available_ram_in_percentage >= $RAM_Thresold" | bc -l) )); then
    
    echo "Warning: Low Memory available (in percentage) :  $available_ram_in_percentage"
    fi
  
  if [ "$cpu_usage" -gt "$CPU_Thresold" ]; then
  
   echo "Warning: Low CPU available (in percentage):  $cpu_usage"

fi




}

trap 'echo "Exiting...";exit' SIGINT

server_monitoring
