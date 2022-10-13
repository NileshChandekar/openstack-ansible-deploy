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

* Configure Ubuntu¶
     * Update package source lists:
     ```
     # apt update -y
     ```
     * Upgrade the system packages and kernel:
     ```
     # apt dist-upgrade -y 
     ```
     * Install additional software packages. 
     ```
     # apt install bridge-utils debootstrap ifenslave ifenslave-2.6 lsof lvm2 openssh-server sudo tcpdump vlan python3 -y 
     ```

Configure the deployment
===


|Role|Type|OS|
|----|----|----|
|Deployer Node|VM|Ubuntu-20.04|


![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-configure-deployment.png)

##### Initial environment configuration¶

* Copy the contents of the ``/opt/openstack-ansible/etc/openstack_deploy`` directory to the ``/etc/openstack_deploy`` directory.

     ```
     root@ubuntu:/opt/openstack-ansible# cp -R etc/openstack_deploy/ /etc/
     ```

* Change to the ``/etc/openstack_deploy`` directory. Here is the config files 
* [openstack_user_config.yml](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/openstack_user_config.yml)
* [user_variables.yml](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/user_variables.yml)


##### Configuring service credentials¶

```
# cd /opt/openstack-ansible
# ./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
```

* To regenerate existing passwords, add the ``--regen`` flag.

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-run-playbooks.png)

##### Run the playbooks to install OpenStack¶

* Change to the ``/opt/openstack-ansible/playbooks`` directory.
* Run the host setup playbook:
```
# openstack-ansible setup-hosts.yml
```
```
PLAY RECAP ********************************************************************
...
deployment_host                :  ok=18   changed=11   unreachable=0    failed=0
```

* Run the infrastructure setup playbook:
```
# openstack-ansible setup-infrastructure.yml
```
```
PLAY RECAP ********************************************************************
...
deployment_host                : ok=27   changed=0    unreachable=0    failed=0
```

* Run the following command to verify the database cluster:
```
ansible galera_container -m shell \
  -a "mysql -h localhost -e 'show status like \"%wsrep_cluster_%\";'"
```

* Run the OpenStack setup playbook:
```
# openstack-ansible setup-openstack.yml
```

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-verify-openstack.png)

##### Verify the API

```
root@firoz-osa-infra-0:~# lxc-ls -f | grep -i utility
infra1_utility_container-13e6957f        RUNNING 1         onboot, openstack 10.0.3.190, 192.168.24.249                -    false        
root@firoz-osa-infra-0:~# 
```

```
root@firoz-osa-infra-0:~# lxc-attach  infra1_utility_container-13e6957f
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# source openrc 
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack  hypervisor list 
+----+----------------------------------+-----------------+---------------+-------+
| ID | Hypervisor Hostname              | Hypervisor Type | Host IP       | State |
+----+----------------------------------+-----------------+---------------+-------+
|  1 | firoz-osa-cmpt-1.openstack.local | QEMU            | 192.168.24.13 | up    |
|  2 | firoz-osa-cmpt-0.openstack.local | QEMU            | 192.168.24.12 | up    |
+----+----------------------------------+-----------------+---------------+-------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack   compute service list  
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
| ID | Binary         | Host                               | Zone     | Status  | State | Updated At                 |
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
|  3 | nova-conductor | infra1-nova-api-container-0e13d343 | internal | enabled | up    | 2022-10-13T18:45:10.000000 |
|  6 | nova-scheduler | infra1-nova-api-container-0e13d343 | internal | enabled | up    | 2022-10-13T18:45:10.000000 |
|  8 | nova-compute   | firoz-osa-cmpt-1                   | nova     | enabled | up    | 2022-10-13T18:45:10.000000 |
|  9 | nova-compute   | firoz-osa-cmpt-0                   | nova     | enabled | up    | 2022-10-13T18:45:11.000000 |
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack   network agent  list  
+--------------------------------------+--------------------+-------------------+-------------------+-------+-------+---------------------------+
| ID                                   | Agent Type         | Host              | Availability Zone | Alive | State | Binary                    |
+--------------------------------------+--------------------+-------------------+-------------------+-------+-------+---------------------------+
| 014b87d0-dc57-42cd-8006-14016a092aad | DHCP agent         | firoz-osa-infra-0 | nova              | :-)   | UP    | neutron-dhcp-agent        |
| 2ca5c1db-6cdf-4ce3-ad29-e51548ad5f7b | Metering agent     | firoz-osa-infra-0 | None              | :-)   | UP    | neutron-metering-agent    |
| 8aa218f2-e5ad-4ed7-b6f8-0064d9804280 | L3 agent           | firoz-osa-infra-0 | nova              | :-)   | UP    | neutron-l3-agent          |
| b635daa8-91c6-4e88-9f18-6885b690cb6a | Linux bridge agent | firoz-osa-infra-0 | None              | :-)   | UP    | neutron-linuxbridge-agent |
| dbf7e4f7-7ea4-4060-9dc9-be44d763d2d8 | Metadata agent     | firoz-osa-infra-0 | None              | :-)   | UP    | neutron-metadata-agent    |
| e5d8cba4-dffb-4ef0-946c-f7400e5403b6 | Linux bridge agent | firoz-osa-cmpt-0  | None              | :-)   | UP    | neutron-linuxbridge-agent |
+--------------------------------------+--------------------+-------------------+-------------------+-------+-------+---------------------------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack  endpoint list
+----------------------------------+-----------+--------------+----------------+---------+-----------+---------------------------------------------+
| ID                               | Region    | Service Name | Service Type   | Enabled | Interface | URL                                         |
+----------------------------------+-----------+--------------+----------------+---------+-----------+---------------------------------------------+
| 0d10f7e54e0f416f86bb501a75bbb506 | RegionOne | heat         | orchestration  | True    | public    | https://192.168.122.9:8004/v1/%(tenant_id)s |
| 0d2fb784e3c14ce686c641af3099f50a | RegionOne | heat         | orchestration  | True    | internal  | http://192.168.24.9:8004/v1/%(tenant_id)s   |
| 3c4f4679e8ff4aeda435049157e792b9 | RegionOne | heat-cfn     | cloudformation | True    | internal  | http://192.168.24.9:8000/v1                 |
| 3d5d50a7e7c24fccb77320e12957bf2e | RegionOne | neutron      | network        | True    | public    | https://192.168.122.9:9696                  |
| 3ef842a09004464ba534b0c823990a4b | RegionOne | cinderv3     | volumev3       | True    | admin     | http://192.168.24.9:8776/v3/%(tenant_id)s   |
| 43511cf941ab48ee884b7d23611a920f | RegionOne | cinderv3     | volumev3       | True    | internal  | http://192.168.24.9:8776/v3/%(tenant_id)s   |
| 5b25a93cf65b49e496bf3d78ca6182f7 | RegionOne | placement    | placement      | True    | internal  | http://192.168.24.9:8780                    |
| 5c6c6178e31241a68633746e76030608 | RegionOne | nova         | compute        | True    | public    | https://192.168.122.9:8774/v2.1             |
| 6da5442ee8814958a75f67aae49d9dc3 | RegionOne | neutron      | network        | True    | admin     | http://192.168.24.9:9696                    |
| 7ab086d8726449e0b4ffaa349f88aec7 | RegionOne | cinderv3     | volumev3       | True    | public    | https://192.168.122.9:8776/v3/%(tenant_id)s |
| 8f9c728a510a4bbd9b6575f48c0b06ee | RegionOne | placement    | placement      | True    | admin     | http://192.168.24.9:8780                    |
| 90f59d1f7af4458db42559d45c3e024e | RegionOne | keystone     | identity       | True    | admin     | http://192.168.24.9:5000                    |
| 94d31a5c77ea43dc97239611855265b3 | RegionOne | heat-cfn     | cloudformation | True    | public    | https://192.168.122.9:8000/v1               |
| a4bffe09fe0b4a86a5650f3a871d3569 | RegionOne | nova         | compute        | True    | internal  | http://192.168.24.9:8774/v2.1               |
| a80b89c5c2a0497eb0875a701348bf25 | RegionOne | keystone     | identity       | True    | internal  | http://192.168.24.9:5000                    |
| b1d99507428245ccaed8c666fcb88075 | RegionOne | nova         | compute        | True    | admin     | http://192.168.24.9:8774/v2.1               |
| b4ce579bc9914672bf7e3335a7f554c7 | RegionOne | keystone     | identity       | True    | public    | https://192.168.122.9:5000                  |
| bcd42762618d42c8b08d65d22f09f0f2 | RegionOne | glance       | image          | True    | public    | https://192.168.122.9:9292                  |
| bfde9bd281c643638b965591b566650b | RegionOne | placement    | placement      | True    | public    | https://192.168.122.9:8780                  |
| c03fc55ac25f4c139e0b173addab9f80 | RegionOne | heat         | orchestration  | True    | admin     | http://192.168.24.9:8004/v1/%(tenant_id)s   |
| e161812c41fd46598c88ac757fd00c95 | RegionOne | heat-cfn     | cloudformation | True    | admin     | http://192.168.24.9:8000/v1                 |
| e2ca94e55b4b4cfebca30814fcd94ffb | RegionOne | glance       | image          | True    | internal  | http://192.168.24.9:9292                    |
| e3977e1cc17f417586fc8368d4a568a0 | RegionOne | glance       | image          | True    | admin     | http://192.168.24.9:9292                    |
| f840ed8379c4407d97e10b33f50e3118 | RegionOne | neutron      | network        | True    | internal  | http://192.168.24.9:9696                    |
+----------------------------------+-----------+--------------+----------------+---------+-----------+---------------------------------------------+
root@infra1-utility-container-13e6957f:~# 
```

* Create a sample network and test if we are able to spawn an instance. [Click Here for Script](https://github.com/NileshChandekar/osp_instance_create_test/blob/main/README.md)

* Verify: 

```
root@infra1-utility-container-13e6957f:~# openstack network list 
+--------------------------------------+---------+--------------------------------------+
| ID                                   | Name    | Subnets                              |
+--------------------------------------+---------+--------------------------------------+
| 3409f0c8-5c80-4fa3-861b-55f8cc5e64c0 | private | 53d61e69-0a56-44b2-9f5e-6cd60b13e2d3 |
+--------------------------------------+---------+--------------------------------------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack  image list 
+--------------------------------------+--------------+--------+
| ID                                   | Name         | Status |
+--------------------------------------+--------------+--------+
| 725adddb-e538-4161-8855-aee00da2e5c8 | cirros_0.3.4 | active |
+--------------------------------------+--------------+--------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack  flavor list 
+------+--------------+-----+------+-----------+-------+-----------+
| ID   | Name         | RAM | Disk | Ephemeral | VCPUs | Is Public |
+------+--------------+-----+------+-----------+-------+-----------+
| auto | m1.tiny.test | 512 |   10 |         0 |     1 | True      |
+------+--------------+-----+------+-----------+-------+-----------+
root@infra1-utility-container-13e6957f:~# 
```

```
root@infra1-utility-container-13e6957f:~# openstack  server list
+--------------------------------------+------------------------------+--------+---------------------+--------------+--------------+
| ID                                   | Name                         | Status | Networks            | Image        | Flavor       |
+--------------------------------------+------------------------------+--------+---------------------+--------------+--------------+
| 1d7a1a07-3985-4cb6-b9d4-62a54df35761 | cirros_A_2022-10-13_11-08-44 | ACTIVE | private=10.10.10.22 | cirros_0.3.4 | m1.tiny.test |
+--------------------------------------+------------------------------+--------+---------------------+--------------+--------------+
root@infra1-utility-container-13e6957f:~# 
```

