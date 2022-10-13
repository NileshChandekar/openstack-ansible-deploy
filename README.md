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


|Network|deployer node|infra-1|compute-0|compute-1|Interfaces|
|----|----|----|----|----|----|
|default network [192.168.122.0/24]|Yes|Yes|Yes|Yes|enp1s0|
|provisioning network [192.168.24.0/24]|Yes|Yes|Yes|Yes|enp2s0|
|vlannet network [172.29.0.0/24]|No|Yes|Yes|Yes|enp3s0|
|public network [192.168.200.0/24]|Yes|Yes|Yes|Yes|enp9s0|



![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-overview.png)


Installation requirements and recommendations¶
===

#### Software requirements¶

* Ensure that all hosts within an OpenStack-Ansible (OSA) environment meet the following minimum requirements:
* Ubuntu
     * Ubuntu 20.04 LTS (Focal Fossa)
     * Linux kernel version 4.15.0-0-generic or later is required.
* Secure Shell (SSH) client and server that support public key authentication
* Network Time Protocol (NTP) client for time synchronization (such as ntpd or chronyd)
* Python 3.6.*x* or 3.8.*x*
* en_US.UTF-8 as the locale


Prepare the deployment host
===

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-deploymenthost.png)

|Role|Type|OS|
|----|----|----|
|Deployer Node|VM|Ubuntu-20.04|


#### Configuring the operating system¶

* Configure Ubuntu¶
     * Update package source lists:
     ```
     # apt update
     ```
     * Upgrade the system packages and kernel:
     ```
     # apt dist-upgrade
     ```
     * Reboot the host. 
     * Install additional software packages if they were not installed during the operating system installation:
     ```
     # apt install build-essential git chrony openssh-server python3-dev sudo
     ```
     * Configure NTP to synchronize with a suitable time source.
     
* Install the source and dependencies¶
     * Clone the latest stable release of the OpenStack-Ansible Git repository in the /opt/openstack-ansible directory:
     ```
     # git clone https://opendev.org/openstack/openstack-ansible /opt/openstack-ansible
     ```
     ```
     root@ubuntu:/opt/openstack-ansible# git branch -vva
     * master                                   e01385fb7 [origin/master] Merge "Bump ansible-core version to 2.13.4"
       remotes/origin/HEAD                      -> origin/master
       remotes/origin/master                    e01385fb7 Merge "Bump ansible-core version to 2.13.4"
       remotes/origin/stable/queens             e9a41ec77 Fix watchdog version
       remotes/origin/stable/rocky              24938f3db Merge "Remove periodic CI jobs for rocky branch" into stable/rocky
       remotes/origin/stable/stein              d12bd110c Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/train              65f0aa5ee Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/ussuri             4ea5b8b24 Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/victoria           7df32250d Merge "Add mistra-extra repo" into stable/victoria
       remotes/origin/stable/wallaby            236e2677f Bump OpenStack-Ansible Wallaby
       remotes/origin/stable/xena               5502f685d Bump OpenStack-Ansible Xena
       remotes/origin/stable/yoga               18f5ea263 Add Rocky Linux 9 to zuul and docs
       root@ubuntu:/opt/openstack-ansible# 
     ```

     ```
     root@ubuntu:/opt/openstack-ansible# git checkout remotes/origin/stable/wallaby
     * (HEAD detached at origin/stable/wallaby) 236e2677f Bump OpenStack-Ansible Wallaby
       master                                   e01385fb7 [origin/master] Merge "Bump ansible-core version to 2.13.4"
       remotes/origin/HEAD                      -> origin/master
       remotes/origin/master                    e01385fb7 Merge "Bump ansible-core version to 2.13.4"
       remotes/origin/stable/queens             e9a41ec77 Fix watchdog version
       remotes/origin/stable/rocky              24938f3db Merge "Remove periodic CI jobs for rocky branch" into stable/rocky
       remotes/origin/stable/stein              d12bd110c Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/train              65f0aa5ee Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/ussuri             4ea5b8b24 Mark OSA repository as safe in git.config in CI
       remotes/origin/stable/victoria           7df32250d Merge "Add mistra-extra repo" into stable/victoria
       remotes/origin/stable/wallaby            236e2677f Bump OpenStack-Ansible Wallaby
       remotes/origin/stable/xena               5502f685d Bump OpenStack-Ansible Xena
       remotes/origin/stable/yoga               18f5ea263 Add Rocky Linux 9 to zuul and docs
       root@ubuntu:/opt/openstack-ansible# 
     ```
   
 * Change to the ``/opt/openstack-ansible`` directory, and run the Ansible bootstrap script:  
      ```
      # cd /opt/openstack-ansible
      ```
      ```
      # scripts/bootstrap-ansible.sh
      ```

|Role|Type|OS|
|----|----|----|
|Overcloud Nodes [target]|VM|Ubuntu-20.04|


![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-targethosts.png)

##### Configuring the operating system¶
