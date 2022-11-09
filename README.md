Step by Step - Openstack-Ansible[OSA] Deployment
===

![logo](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/images/openstack-ansible.png)

Click on Link for Choice of Deployment. 
===

[Train](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/train.md)
---

[Wallaby](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/wallaby-deployment.md)
---


Click on Link for Choice of Upgrade. 
===

[Train to Ussuri](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/train.md)
---

[Ussuri to Victoria](https://github.com/NileshChandekar/openstack-ansible-deploy/blob/main/train.md)
---


Basic Openration:
===

a) Show all groups and which hosts belong to them:

```
+---------------------------+------------------------------------------+
| groups                    | container_name                           |
+---------------------------+------------------------------------------+
| cinder_api                | infra0_cinder_api_container-4f8acb46     |
|                           | infra1_cinder_api_container-7c200c69     |
|                           | infra2_cinder_api_container-de916aa4     |
| cinder_api_container      | infra0_cinder_api_container-4f8acb46     |
|                           | infra1_cinder_api_container-7c200c69     |
|                           | infra2_cinder_api_container-de916aa4     |
| cinder_backup             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| cinder_scheduler          | infra0_cinder_api_container-4f8acb46     |
|                           | infra1_cinder_api_container-7c200c69     |
|                           | infra2_cinder_api_container-de916aa4     |
| cinder_volume             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| compute-infra_all         | infra0                                   |
|                           | infra0_nova_api_container-3c3ab53f       |
|                           | infra1                                   |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2                                   |
|                           | infra2_nova_api_container-bde2baae       |
| compute-infra_hosts       | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| compute_all               | compute0                                 |
|                           | compute1                                 |
| compute_hosts             | compute0                                 |
|                           | compute1                                 |
| dashboard_all             | infra0                                   |
|                           | infra0_horizon_container-d15577e3        |
|                           | infra1                                   |
|                           | infra1_horizon_container-2e09eb7d        |
|                           | infra2                                   |
|                           | infra2_horizon_container-c396617f        |
| dashboard_hosts           | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| galera                    | infra0_galera_container-9517af1e         |
|                           | infra1_galera_container-f643de7b         |
|                           | infra2_galera_container-85ca64a4         |
| galera_container          | infra0_galera_container-9517af1e         |
|                           | infra1_galera_container-f643de7b         |
|                           | infra2_galera_container-85ca64a4         |
| glance_api                | infra0_glance_container-6d34251f         |
|                           | infra1_glance_container-e255764f         |
|                           | infra2_glance_container-48bfb588         |
| glance_container          | infra0_glance_container-6d34251f         |
|                           | infra1_glance_container-e255764f         |
|                           | infra2_glance_container-48bfb588         |
| glance_registry           | infra0_glance_container-6d34251f         |
|                           | infra1_glance_container-e255764f         |
|                           | infra2_glance_container-48bfb588         |
| haproxy                   | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| haproxy_all               | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| haproxy_hosts             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| heat_api                  | infra0_heat_api_container-b1721561       |
|                           | infra1_heat_api_container-7c7e908b       |
|                           | infra2_heat_api_container-c614536a       |
| heat_api_cfn              | infra0_heat_api_container-b1721561       |
|                           | infra1_heat_api_container-7c7e908b       |
|                           | infra2_heat_api_container-c614536a       |
| heat_api_container        | infra0_heat_api_container-b1721561       |
|                           | infra1_heat_api_container-7c7e908b       |
|                           | infra2_heat_api_container-c614536a       |
| heat_engine               | infra0_heat_api_container-b1721561       |
|                           | infra1_heat_api_container-7c7e908b       |
|                           | infra2_heat_api_container-c614536a       |
| horizon                   | infra0_horizon_container-d15577e3        |
|                           | infra1_horizon_container-2e09eb7d        |
|                           | infra2_horizon_container-c396617f        |
| horizon_container         | infra0_horizon_container-d15577e3        |
|                           | infra1_horizon_container-2e09eb7d        |
|                           | infra2_horizon_container-c396617f        |
| identity_all              | infra0                                   |
|                           | infra0_keystone_container-18f2fdaa       |
|                           | infra1                                   |
|                           | infra1_keystone_container-ddcc4034       |
|                           | infra2                                   |
|                           | infra2_keystone_container-8a0e89e2       |
| identity_hosts            | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| image_all                 | infra0                                   |
|                           | infra0_glance_container-6d34251f         |
|                           | infra1                                   |
|                           | infra1_glance_container-e255764f         |
|                           | infra2                                   |
|                           | infra2_glance_container-48bfb588         |
| image_hosts               | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| infra0-host_containers    | infra0_memcached_container-0eedecd4      |
|                           | infra0_cinder_api_container-4f8acb46     |
|                           | infra0_nova_api_container-3c3ab53f       |
|                           | infra0_utility_container-56f52818        |
|                           | infra0_glance_container-6d34251f         |
|                           | infra0_rabbit_mq_container-a1d4ab4e      |
|                           | infra0_horizon_container-d15577e3        |
|                           | infra0_repo_container-b7960623           |
|                           | infra0_placement_container-b968b295      |
|                           | infra0_galera_container-9517af1e         |
|                           | infra0_neutron_server_container-73320d14 |
|                           | infra0_keystone_container-18f2fdaa       |
|                           | infra0_heat_api_container-b1721561       |
| infra1-host_containers    | infra1_memcached_container-e9c6d879      |
|                           | infra1_cinder_api_container-7c200c69     |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra1_utility_container-3b305e95        |
|                           | infra1_glance_container-e255764f         |
|                           | infra1_rabbit_mq_container-9c076894      |
|                           | infra1_horizon_container-2e09eb7d        |
|                           | infra1_repo_container-6b1b72db           |
|                           | infra1_placement_container-84ed6142      |
|                           | infra1_galera_container-f643de7b         |
|                           | infra1_neutron_server_container-8d722819 |
|                           | infra1_keystone_container-ddcc4034       |
|                           | infra1_heat_api_container-7c7e908b       |
| infra2-host_containers    | infra2_memcached_container-df000521      |
|                           | infra2_cinder_api_container-de916aa4     |
|                           | infra2_nova_api_container-bde2baae       |
|                           | infra2_utility_container-e0ff5981        |
|                           | infra2_glance_container-48bfb588         |
|                           | infra2_rabbit_mq_container-7100d578      |
|                           | infra2_horizon_container-c396617f        |
|                           | infra2_repo_container-029e58ca           |
|                           | infra2_placement_container-0a7328c3      |
|                           | infra2_galera_container-85ca64a4         |
|                           | infra2_neutron_server_container-d5e6ac1d |
|                           | infra2_keystone_container-8a0e89e2       |
|                           | infra2_heat_api_container-c614536a       |
| keystone                  | infra0_keystone_container-18f2fdaa       |
|                           | infra1_keystone_container-ddcc4034       |
|                           | infra2_keystone_container-8a0e89e2       |
| keystone_container        | infra0_keystone_container-18f2fdaa       |
|                           | infra1_keystone_container-ddcc4034       |
|                           | infra2_keystone_container-8a0e89e2       |
| lxc_hosts                 | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| memcached                 | infra0_memcached_container-0eedecd4      |
|                           | infra1_memcached_container-e9c6d879      |
|                           | infra2_memcached_container-df000521      |
| memcached_container       | infra0_memcached_container-0eedecd4      |
|                           | infra1_memcached_container-e9c6d879      |
|                           | infra2_memcached_container-df000521      |
| network_all               | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
|                           | infra0_neutron_server_container-73320d14 |
|                           | infra1_neutron_server_container-8d722819 |
|                           | infra2_neutron_server_container-d5e6ac1d |
| network_hosts             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_agent             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_bgp_dragent       | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_dhcp_agent        | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_l3_agent          | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_linuxbridge_agent | compute0                                 |
|                           | compute1                                 |
|                           | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_metadata_agent    | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_metering_agent    | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_openvswitch_agent | compute0                                 |
|                           | compute1                                 |
|                           | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| neutron_server            | infra0_neutron_server_container-73320d14 |
|                           | infra1_neutron_server_container-8d722819 |
|                           | infra2_neutron_server_container-d5e6ac1d |
| neutron_server_container  | infra0_neutron_server_container-73320d14 |
|                           | infra1_neutron_server_container-8d722819 |
|                           | infra2_neutron_server_container-d5e6ac1d |
| neutron_sriov_nic_agent   | compute0                                 |
|                           | compute1                                 |
|                           | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| nova_api_container        | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| nova_api_metadata         | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| nova_api_os_compute       | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| nova_compute              | compute0                                 |
|                           | compute1                                 |
| nova_conductor            | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| nova_console              | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| nova_scheduler            | infra0_nova_api_container-3c3ab53f       |
|                           | infra1_nova_api_container-b7d099d2       |
|                           | infra2_nova_api_container-bde2baae       |
| opendaylight              | infra0_neutron_server_container-73320d14 |
|                           | infra1_neutron_server_container-8d722819 |
|                           | infra2_neutron_server_container-d5e6ac1d |
| orchestration_all         | infra0                                   |
|                           | infra0_heat_api_container-b1721561       |
|                           | infra1                                   |
|                           | infra1_heat_api_container-7c7e908b       |
|                           | infra2                                   |
|                           | infra2_heat_api_container-c614536a       |
| orchestration_hosts       | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| pkg_repo                  | infra0_repo_container-b7960623           |
|                           | infra1_repo_container-6b1b72db           |
|                           | infra2_repo_container-029e58ca           |
| placement-infra_all       | infra0                                   |
|                           | infra0_placement_container-b968b295      |
|                           | infra1                                   |
|                           | infra1_placement_container-84ed6142      |
|                           | infra2                                   |
|                           | infra2_placement_container-0a7328c3      |
| placement-infra_hosts     | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| placement_api             | infra0_placement_container-b968b295      |
|                           | infra1_placement_container-84ed6142      |
|                           | infra2_placement_container-0a7328c3      |
| placement_container       | infra0_placement_container-b968b295      |
|                           | infra1_placement_container-84ed6142      |
|                           | infra2_placement_container-0a7328c3      |
| rabbit_mq_container       | infra0_rabbit_mq_container-a1d4ab4e      |
|                           | infra1_rabbit_mq_container-9c076894      |
|                           | infra2_rabbit_mq_container-7100d578      |
| rabbitmq                  | infra0_rabbit_mq_container-a1d4ab4e      |
|                           | infra1_rabbit_mq_container-9c076894      |
|                           | infra2_rabbit_mq_container-7100d578      |
| repo-infra_all            | infra0                                   |
|                           | infra0_repo_container-b7960623           |
|                           | infra1                                   |
|                           | infra1_repo_container-6b1b72db           |
|                           | infra2                                   |
|                           | infra2_repo_container-029e58ca           |
| repo-infra_hosts          | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| repo_container            | infra0_repo_container-b7960623           |
|                           | infra1_repo_container-6b1b72db           |
|                           | infra2_repo_container-029e58ca           |
| shared-infra_all          | infra0                                   |
|                           | infra0_memcached_container-0eedecd4      |
|                           | infra1                                   |
|                           | infra1_memcached_container-e9c6d879      |
|                           | infra2                                   |
|                           | infra2_memcached_container-df000521      |
|                           | infra0_utility_container-56f52818        |
|                           | infra1_utility_container-3b305e95        |
|                           | infra2_utility_container-e0ff5981        |
|                           | infra0_rabbit_mq_container-a1d4ab4e      |
|                           | infra1_rabbit_mq_container-9c076894      |
|                           | infra2_rabbit_mq_container-7100d578      |
|                           | infra0_galera_container-9517af1e         |
|                           | infra1_galera_container-f643de7b         |
|                           | infra2_galera_container-85ca64a4         |
| shared-infra_hosts        | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| storage-infra_all         | infra0                                   |
|                           | infra0_cinder_api_container-4f8acb46     |
|                           | infra1                                   |
|                           | infra1_cinder_api_container-7c200c69     |
|                           | infra2                                   |
|                           | infra2_cinder_api_container-de916aa4     |
| storage-infra_hosts       | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| storage_all               | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| storage_hosts             | infra0                                   |
|                           | infra1                                   |
|                           | infra2                                   |
| utility                   | infra0_utility_container-56f52818        |
|                           | infra1_utility_container-3b305e95        |
|                           | infra2_utility_container-e0ff5981        |
| utility_container         | infra0_utility_container-56f52818        |
|                           | infra1_utility_container-3b305e95        |
|                           | infra2_utility_container-e0ff5981        |
+---------------------------+------------------------------------------+
```

b) Check for group ``galera_container`` whether all nodes are in SYNC. 
```
root@cc9862ae97a6:/opt/openstack-ansible# ansible galera_container -m shell -a "clustercheck"
```

```
infra1_galera_container-f643de7b | CHANGED | rc=0 >>
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close
Content-Length: 40

Percona XtraDB Cluster Node is synced.

infra2_galera_container-85ca64a4 | CHANGED | rc=0 >>
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close
Content-Length: 40

Percona XtraDB Cluster Node is synced.

infra0_galera_container-9517af1e | CHANGED | rc=0 >>
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close
Content-Length: 40

Percona XtraDB Cluster Node is synced.
```

b) 
