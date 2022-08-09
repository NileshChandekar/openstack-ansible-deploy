
#!/bin/bash

user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')
for i in $( sudo virsh list --all | grep -i $user | egrep -i "osp" | awk {'print $2'} ) ; \
do virsh destroy $i ; done

for i in $(sudo virsh list --all | grep -i $user | egrep -i "osp" | awk {'print $2'} ) ; \
do virsh undefine  $i ; done

rm -fr /openstack/images/deployosp/* 
mkdir /tmp/osptxtfiles

clear
read -p "Enter Controller Count: " con
read -p "Enter Compute Count: " com
read -p "Enter Controller Memory Size: " mem_con
read -p "Enter Compute Memory Size: " mem_com

clear

echo -e "\033[1;36mCreating osp Deploy OS Directory\033[0m"


if ! ls -al /openstack/images/deployosp ; then
  echo "Creating Directory" ; \
    mkdir /openstack/images/deployosp ;\
  else
    echo "Directory already exist."
fi

cd /openstack/images/deployosp/



echo -e "\033[1;36mCreating Guest Qcow2\033[0m"

### Create guest qcow2

if ! ls -al centos8-guest.qcow2 ; then   
    echo "Creating centos8-guest qcow2 image" ; \
    qemu-img create -f qcow2 centos8-guest.qcow2 80G ;  \
else     
    echo "Guest Image already exist."; 
fi

echo -e "\033[1;36mDownloading Image\033[0m"

### Downloading image 
  
if ! ls -al CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2 ; then   
   echo "Downloading Centos-8 Server Image" ; \
   curl -O https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2 ; \
else     
    echo "Server Image already exist."; 
fi

echo -e "\033[1;36mModify Image\033[0m"

### Virt resize

cd /openstack/images/deployosp/
virt-resize --expand /dev/sda1 \
/openstack/images/deployosp/CentOS-Stream-GenericCloud-8-20220125.1.x86_64.qcow2 \
/openstack/images/deployosp/centos8-guest.qcow2


cd /openstack/images/deployosp/
qemu-img create \
-f qcow2 \
-b /openstack/images/deployosp/centos8-guest.qcow2 \
/openstack/images/deployosp/dummy-osp-node.qcow2

virt-customize \
-a /openstack/images/deployosp/dummy-osp-node.qcow2 \
--root-password password:0 \
--uninstall cloud-init





echo -e "\033[1;36mCreating osp $con OS Disk\033[0m"
user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')
i=0
j=0
for a in `seq 1 $con` ; \
do cp /openstack/images/deployosp/dummy-osp-node.qcow2 $user-osp-con-node-$((j++)).qcow2 ; \
done 

echo -e "\033[1;36mCreating osp $com OS Disk\033[0m"
user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')
i=0
j=0
for i in `seq 1 $com` ; \
do cp /openstack/images/deployosp/dummy-osp-node.qcow2 $user-osp-com-node-$((j++)).qcow2 ; \
done 


echo -e "\033[1;36mSpawning $con osp controller\033[0m"
user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')
i=0
j=0
cmd_osp() {
    sudo virt-install \
    --name $user-osp-con-node-$((i++)) \
    --ram $mem_con \
    --vcpus 4 \
    --disk path=/openstack/images/deployosp/$user-osp-con-node-$((j++)).qcow2,device=disk,bus=virtio,format=qcow2 \
    --os-variant fedora10 \
    --import \
    --vnc \
    --noautoconsole \
    --network bridge=clust_br5,model=virtio \
    --network network:public_network 
}

for a in `seq 1 $con`; do cmd_osp ; done

echo -e "\033[1;36mSpawning $com osp comupte\033[0m"
i=0
j=0
cmd_osp() {
    sudo virt-install \
    --name $user-osp-com-node-$((i++)) \
    --ram $mem_com \
    --vcpus 4 \
    --disk path=/openstack/images/deployosp/$user-osp-com-node-$((j++)).qcow2,device=disk,bus=virtio,format=qcow2 \
    --os-variant fedora10 \
    --import \
    --vnc \
    --noautoconsole \
    --network bridge=clust_br5,model=virtio \
    --network network:public_network 
}

for a in `seq 1 $com`; do cmd_osp ; done



echo -e "\033[1;36mGetting IP details\033[0m"


sleep 20 

for IP in $(sudo virsh list --all | grep -i osp | awk {'print $2'}); \
do sudo virsh domifaddr $IP| awk {'print $4'} | awk 'NR>2'|  cut -d'/' -f1; \
done  > /tmp/osptxtfiles/ip.txt


echo -e "\033[1;36mGetting HOSTENTRY Point\033[0m"

user=$(id | awk '{print $1}' | sed 's/.*(//;s/)$//')

for ADDR in $(sudo virsh list --all | grep -i osp | awk {'print $2'}); \
do echo $ADDR ;  \
sudo virsh domifaddr $ADDR | egrep -i 192 | awk {'print $4'} ; \
done > /tmp/osptxtfiles/1.txt ; \
sed 'N;s/\n/ /'  /tmp/osptxtfiles/1.txt > /tmp/osptxtfiles/2.txt ; \
cat /tmp/osptxtfiles/2.txt | cut -d "/" -f1 > /tmp/osptxtfiles/3.txt ; \
cat /tmp/osptxtfiles/3.txt | awk '{ print $NF"     "  $1 }' > /tmp/osptxtfiles/hostentry.txt

clear 

for p in $(cat /tmp/osptxtfiles/ip.txt); do ping -c1 $p; done

sleep 5 

clear 

cat /tmp/osptxtfiles/hostentry.txt
