#!/bin/bash
### Inside Container.
user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')
apt update -y
apt install openssh-server -y
apt install sshpass -y
apt install vim -y
apt install iputils-ping -y 
systemctl restart sshd
systemctl status  sshd
for host in $(cat /ip.txt); do echo $host; sshpass -p 0 ssh-copy-id -o StrictHostKeyChecking=no  root@$host  ; done
