#!/bin/bash

clear
echo "#######################################"
echo "############# ~Brooksify~ #############"
echo "#######################################"
echo -e

## Get inputs
read -p "Enter FQDN: " fqdn

## Check for invalid FQDN, format to break up into variables
regex='([a-z0-9]+)[\.]([a-z0-9]+)*\.([a-z]+)'
if [[ $fqdn =~ $regex ]]; then
    hostname=${BASH_REMATCH[1]}
    domain=${BASH_REMATCH[2]}"."${BASH_REMATCH[3]}
else
    echo "Incorrect FQDN"
    exit
fi

## Continue with inputs
read -p "Enter IP: " ip
read -p "Enter username: " username
read -s -p "Enter password: " password
echo -e
read -p "Enter full name: " fullname
echo -e "\n ** Brooksifying ** \n"

## Customize shell
sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/g" ~/.bashrc
source ~/.bashrc

## Input hostname and ip into /etc/hosts
echo -e "\n\n# Added by brooksifier\n${ip} ${fqdn} ${hostname}" | sudo tee -a /etc/hosts

## Input hostname into /etc/hostname
echo -e "${hostname}" | sudo tee /etc/hostname
sudo service hostname restart

## Add username
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
    echo "$username already exists!"
    exit
else
    ## Encrypt typed password
    encrypted_password=$(perl -e 'print crypt($ARGV[0], "password")' $password)

    ## Create new user
    sudo useradd -m --shell /bin/bash -p $encrypted_password $username
    sudo usermod -c "$fullname" $username
    if [ $? -eq 0 ] ; then
        echo "User $username has been added to system"
    else
        echo "Failed to add user $username"
    fi
    
    ## Copy authorized_keys to new user
    sudo adduser $username admin
    sudo -u $username mkdir /home/$username/.ssh/
    sudo cp .ssh/authorized_keys /home/$username/.ssh/
    sudo chown $username:$username /home/$username/.ssh/authorized_keys
fi

## Run updates and restart if required
sudo apt-get update && sudo apt-get -y dist-upgrade
if [ -f /var/run/reboot-required ]; then sudo shutdown -r now; fi
