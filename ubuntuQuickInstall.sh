#!/bin/bash

echo -n "FQDN: "
read fqdn

echo -n "IP: "
read ip

echo -n "Local Administrator name: "
read ladmin

regex='([a-z0-9]+)[\.]([a-z0-9]+)*\.([a-z]+)'
if [[ $fqdn =~ $regex ]]; then
    hostname=${BASH_REMATCH[1]}
    domain=${BASH_REMATCH[2]}"."${BASH_REMATCH[3]}
else
    echo "Incorrect FQDN"
fi

sed -i "s/#force_color_prompt=yes/force_color_prompt=yes/g" ~/.bashrc
source ~/.bashrc
echo -e "\n\n# Added by ubuntuQuickInstall\n${ip} ${fqdn} ${hostname}" | sudo tee -a /etc/hosts
echo -e "${hostname}" | sudo tee /etc/hostname
sudo service hostname restart

