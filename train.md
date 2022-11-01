Step by Step - Openstack-Ansible[OSA] Deployment
===

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/index.png)

* OpenStack-Ansible (OSA) uses the Ansible IT automation engine to deploy an OpenStack environment on Ubuntu, with CentOS and openSUSE. 

Compatibility Matrix
===


|OpenStack Releases|Ubuntu|Kernel|
|----|----|----|
|Train |18.04.6|4.15.0-194-generic|

Deployment Strategy:
===

* Hypervisor: [Virtual-Networks]

```
root@617579-logging01:~# virsh net-list
 Name           State    Autostart   Persistent
-------------------------------------------------
 external       active   yes         yes
 providernet    active   yes         yes
 vlan           active   yes         yes
 provisioning   active   yes         yes

root@617579-logging01:~# 
```


Sample Network Interfaces Config
===

* [infraNode](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/train-infra-interfaces.yaml)
* [ComputeNode](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/train-compute-interfaces.yaml)


![Book logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/Screenshot%202022-10-13%20at%205.58.03%20PM.png)


|Network|infra-* + [deployer node]|compute-*|Interfaces|
|----|----|----|----|
|external network [192.168.122.0/24]|Yes|Yes|enp1s0|
|providernet network [192.168.200.0/24]|Yes|Yes|enp2s0|
|vlannet network [172.29.0.0/24]|Yes|Yes|enp3s0|
|provisioning network [192.168.24.0/24]|Yes|Yes|enp4s0|


Installation requirements and recommendations¶
===

Prepare the deployment host
===

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-deploymenthost.png)

|Role|Type|OS|
|----|----|----|
|Infra-0 Node [ Deployer Node ]|VM|Ubuntu-18.04|


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
     # apt-get install aptitude build-essential git ntp ntpdate openssh-server python-dev sudo
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
     * (HEAD detached at origin/stable/train)   65f0aa5ee Bump OpenStack-Ansible Wallaby
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
|Overcloud Nodes [target]|VM|Ubuntu-18.04|


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
|Deployer Node|VM|Ubuntu-18.04|


![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-configure-deployment.png)

##### Initial environment configuration¶

* Copy the contents of the ``/opt/openstack-ansible/etc/openstack_deploy`` directory to the ``/etc/openstack_deploy`` directory.

     ```
     root@ubuntu:/opt/openstack-ansible# cp -R etc/openstack_deploy/ /etc/
     ```

* Change to the ``/etc/openstack_deploy`` directory. Here is the config files 

* [openstack_user_config.yml](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/train-openstack-user-config.yaml)
* [user_variables.yml](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/sampleconfigs/train-user-variable.yaml)


##### Configuring service credentials¶

```
# cd /opt/openstack-ansible
# ./scripts/pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml
```

* To regenerate existing passwords, add the ``--regen`` flag.

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/installation-workflow-run-playbooks.png)

##### Run the playbooks to install OpenStack

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
root@mukesh-osa-bionic-infra-0:/opt/openstack-ansible/playbooks# lxc-ls -f | grep -i uti
infra0_utility_container-16ba5dcf        RUNNING 1         onboot, openstack 10.0.3.247, 192.168.24.241                 -    false        
root@mukesh-osa-bionic-infra-0:/opt/openstack-ansible/playbooks# 
```

```
root@mukesh-osa-bionic-infra-0:/opt/openstack-ansible/playbooks# lxc-attach -n infra0_utility_container-16ba5dcf
root@infra0-utility-container-16ba5dcf:/# 
```

```
root@infra0-utility-container-16ba5dcf:~# source openrc 
```

```
root@infra0-utility-container-16ba5dcf:~# openstack hypervisor list
+----+------------------------------------------+-----------------+---------------+-------+
| ID | Hypervisor Hostname                      | Hypervisor Type | Host IP       | State |
+----+------------------------------------------+-----------------+---------------+-------+
|  1 | mukesh-osa-bionic-cmpt-0.openstack.local | QEMU            | 192.168.24.93 | up    |
|  4 | mukesh-osa-bionic-cmpt-1.openstack.local | QEMU            | 192.168.24.94 | up    |
+----+------------------------------------------+-----------------+---------------+-------+
root@infra0-utility-container-16ba5dcf:~# 
```

```
root@infra0-utility-container-16ba5dcf:~# openstack compute service list
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
| ID | Binary         | Host                               | Zone     | Status  | State | Updated At                 |
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
|  7 | nova-conductor | infra0-nova-api-container-73db2d67 | internal | enabled | up    | 2022-11-01T13:04:21.000000 |
| 16 | nova-scheduler | infra0-nova-api-container-73db2d67 | internal | enabled | up    | 2022-11-01T13:04:15.000000 |
| 43 | nova-conductor | infra1-nova-api-container-cccb0d2b | internal | enabled | up    | 2022-11-01T13:04:16.000000 |
| 49 | nova-conductor | infra2-nova-api-container-b6fb645f | internal | enabled | up    | 2022-11-01T13:04:16.000000 |
| 52 | nova-scheduler | infra1-nova-api-container-cccb0d2b | internal | enabled | up    | 2022-11-01T13:04:20.000000 |
| 61 | nova-scheduler | infra2-nova-api-container-b6fb645f | internal | enabled | up    | 2022-11-01T13:04:19.000000 |
| 70 | nova-compute   | mukesh-osa-bionic-cmpt-0           | nova     | enabled | up    | 2022-11-01T13:04:19.000000 |
| 73 | nova-compute   | mukesh-osa-bionic-cmpt-1           | nova     | enabled | up    | 2022-11-01T13:04:19.000000 |
+----+----------------+------------------------------------+----------+---------+-------+----------------------------+
root@infra0-utility-container-16ba5dcf:~# 
```

```
root@infra0-utility-container-16ba5dcf:~# openstack   network agent  list 
+--------------------------------------+----------------+---------------------------+-------------------+-------+-------+------------------------+
| ID                                   | Agent Type     | Host                      | Availability Zone | Alive | State | Binary                 |
+--------------------------------------+----------------+---------------------------+-------------------+-------+-------+------------------------+
| 212d5ea8-b768-444e-b798-4c0894c48f1b | DHCP agent     | mukesh-osa-bionic-infra-2 | nova              | :-)   | UP    | neutron-dhcp-agent     |
| 2a2f29d6-c845-421e-ae88-0d632b0a53bb | Metering agent | mukesh-osa-bionic-infra-2 | None              | :-)   | UP    | neutron-metering-agent |
| 2d934c3a-2134-4eae-95d9-c35974238e23 | Metadata agent | mukesh-osa-bionic-infra-1 | None              | :-)   | UP    | neutron-metadata-agent |
| 3436f780-c099-42bb-8076-5853a50f6faa | Metadata agent | mukesh-osa-bionic-infra-2 | None              | :-)   | UP    | neutron-metadata-agent |
| 5081efea-baf4-449f-b2f4-5996632dca0d | L3 agent       | mukesh-osa-bionic-infra-1 | nova              | :-)   | UP    | neutron-l3-agent       |
| 6eb97385-d2cc-4c74-b3d6-6cc412f00850 | Metadata agent | mukesh-osa-bionic-infra-0 | None              | :-)   | UP    | neutron-metadata-agent |
| 74acc5b7-8574-4b33-9784-55cf5821ce19 | DHCP agent     | mukesh-osa-bionic-infra-1 | nova              | :-)   | UP    | neutron-dhcp-agent     |
| 7f7be014-66a6-4220-b5ee-4018bcaf76f1 | Metering agent | mukesh-osa-bionic-infra-1 | None              | :-)   | UP    | neutron-metering-agent |
| a7768e33-bafa-4b0b-8536-201f4b86f809 | DHCP agent     | mukesh-osa-bionic-infra-0 | nova              | :-)   | UP    | neutron-dhcp-agent     |
| cdf36b3a-f6e8-451f-b8cd-c512d496dd2f | L3 agent       | mukesh-osa-bionic-infra-2 | nova              | :-)   | UP    | neutron-l3-agent       |
| ce4a420e-9255-4767-b11a-6b2439ffa708 | Metering agent | mukesh-osa-bionic-infra-0 | None              | :-)   | UP    | neutron-metering-agent |
| f6a9220d-613d-4caa-b3af-c7ca1af018b1 | L3 agent       | mukesh-osa-bionic-infra-0 | nova              | :-)   | UP    | neutron-l3-agent       |
+--------------------------------------+----------------+---------------------------+-------------------+-------+-------+------------------------+
root@infra0-utility-container-16ba5dcf:~# 
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

