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


![Image ipa](https://github.com/NileshChandekar/lxd_containers/blob/master/images/01111.png)



|Role|FQDN|
|----|----|
|Deployer Node|Container|


