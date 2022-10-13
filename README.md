Step by Step - Openstack-Ansible[OSA] Deployment
===

* OpenStack-Ansible (OSA) uses the Ansible IT automation engine to deploy an OpenStack environment on Ubuntu, with CentOS and openSUSE. 

Compatibility Matrix
===


|OpenStack Releases|Ubuntu|Kernel|
|----|----|----|
|Wallaby |20.04|5.4.0-128-generic|

Deployment Strategy:
===

* Hypervisor: [Virtual-Networks]

```
root@617579-logging01:~# virsh net-list
 Name              State    Autostart   Persistent
----------------------------------------------------
 cluster_network   active   yes         yes
 default           active   yes         yes
 provisioning      active   yes         yes
 public_network    active   yes         yes
 vlannet           active   yes         yes

root@617579-logging01:~# 
```
* Ceph Network

```
root@617579-logging01:~# virsh net-list | egrep -i "cluster_network|public_network"
 cluster_network   active   yes         yes
 public_network    active   yes         yes
root@617579-logging01:~# 
```

![Book logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/Screenshot%202022-10-13%20at%205.58.03%20PM.png)


|Network|deployer nodeinfra-1|compute-0|compute-1
|----|----|----|----|----|
|default network [192.168.122.0/24]|Yes|Yes|Yes|Yes|
|provisioning network [192.168.24.0/24]|Yes|Yes|Yes|Yes|
|vlannet network [172.29.0.0/24]|No|Yes|Yes|Yes|
|public network [192.168.200.0/24]|Yes|Yes|Yes|Yes|




|Role|FQDN|
|----|----|
|Deployer Node|Container|


