#! /bin/bash

## Taking the input from user 

read -p "Enter the username: " username
read -p "Purpose of the user creation: " comment
read -p "Enter the home directory of user [Default - /home/$username]: " home_dir
home_dir="${home_dir:-/home/$username}"
read -p "Enter the maximum password day [Default - 60 Days]: " max_pass
max_pass="${max_pass:-60}"
read -p "Enter the minimum password day [Default - 7 Days]: " min_pass
min_pass="${min_pass:-7}"
read -p "Enter the shell of user [Default - /bin/bash]: " user_shell
user_shell="${user_shell:-/bin/bash}"
read -sp "Enter the password of user: " password
echo 

## Defining the function for user creation

user_addition(){
if id "$username" &>/dev/null; then
echo "user ${username} is already exist"
exit 1
else
echo "user creation is initiated"
useradd -c "${comment}" -m -d "${home_dir}" -s "${user_shell}"  "${username}"
chage -m "${min_pass}" -M "${max_pass}" "${username}"
echo "user creation is done successfully"
fi
echo "Setting the password.."
echo  $username:$password | chpasswd
echo "password is configured successfully"
}

## calling the function to create the user
user_addition
