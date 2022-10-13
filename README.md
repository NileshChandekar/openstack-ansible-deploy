Step by Step - Openstack-Ansible[OSA] Deployment
============================================

* OpenStack-Ansible (OSA) uses the Ansible IT automation engine to deploy an OpenStack environment on Ubuntu, with CentOS and openSUSE. 


.. note::

   If Object Storage hosts exist in the environment, the following
   variables are automatically set in the
   ``/etc/openstack_deploy/user_local_variables.yml`` file to use
   Object Storage:

   - ``glance_default_store`` variable is set to ``swift``

   - ``cinder_service_backup_program_enabled`` variable is set to ``True``
