#!/bin/bash
clear
echo -e "\033[1;36mDelete Environemnt\033[0m"
user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')

echo -e "\033[1;36mDelete existing running VM:s Under $user user\033[0m"
sudo virsh list --all | grep -i $user | grep -i osa
for v in \$(sudo virsh list --all | grep -i $user | grep -i osa | awk {'print $2'}); do sudo virsh destroy $v; sudo virsh undefine $v ; done > /dev/null

echo -e "\033[1;36mRemove associated disk\033[0m"
sudo rm -fr /openstack/images/bionic/$user*
sudo rm -fr /tmp/$user/*
echo -e "\033[1;36mEnv removed\033[0m"
