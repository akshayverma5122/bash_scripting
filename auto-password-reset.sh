#! /bin/bash 

# password warning days 
password_warning_days=7

# capture the user list in linux server
userlist=$(cat /etc/passwd | awk -F ':' '$3 >= 1000 && $3 < 65534 {print $1}')

# changing the password 
for user in $userlist; do

# capturing the password expiry days of user
password_expiry_days=$(expr $(date -d "$(chage -l "${user}" | grep 'Password expires' | cut -d: -f2)" +%s) / 86400 - $(date +%s) / 86400)

# checking if password is going to expiry withing 7 days 
if [ "$password_expiry_days" -le "$password_warning_days" ]; then

# Display the user if password is going to expiry within 7 days 
echo "password of $user is going to expiry in $password_expiry_days"

# generating the new random password  
new_password=$(openssl rand -base64 16)

# changing the password of user
echo  $user:$new_password | chpasswd

# checking if password is getting changed
if [ $? -eq 0 ]; then 

# Display message if password has been changed
echo "password of $user has been changed successfully"

# Enter new empty line
echo 
else

# Display message if password has not been changed
echo "Failed to change the password for $user"
fi


else

# Display message if password is not going to expiry within 7 days
echo "password of user $user is not going to expiry within $password_warning_days days"
fi 
done
