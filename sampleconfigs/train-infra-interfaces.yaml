root@mukesh-osa-bionic-infra-0:/opt/openstack-ansible/playbooks# cat /etc/network/interfaces
# Physical interface
                                                  
auto enp1s0       
iface enp1s0 inet dhcp    
                                                  
auto enp2s0              
iface enp2s0 inet dhcp   
                                                  
auto enp3s0                                       
iface enp3s0 inet manual                          
                                                  
auto enp4s0          
iface enp4s0 inet manual   
                                                  
                                                  
                                                  
# OpenStack Networking VXLAN (tunnel/overlay) VLAN interface
auto enp3s0.30              
iface enp3s0.30 inet manual
    vlan-raw-device enp3s0 
                                                  
# Storage network VLAN interface (optional)       
auto enp3s0.20                                    
iface enp3s0.20 inet manual                                                                         
    vlan-raw-device enp3s0                                                                          

# Container/Host management bridge ## Control-Plane Net
auto br-mgmt                                      
iface br-mgmt inet static
    bridge_stp off        
    bridge_waitport 0                             
    bridge_fd 0          
    bridge_ports enp4s0  
    address 192.168.24.90                         
    netmask 255.255.255.0                         
                                                  
                                                  
# Bind the Internal VIP
auto br-mgmt:0             
iface br-mgmt:0 inet static                       
    address 192.168.24.100                        
    netmask 255.255.255.255                       
                                                                                                    
# Binnd the External VIP    
auto enp1s0:0               
iface enp1s0:0 inet static 
    address 192.168.122.100                       
    netmask 255.255.255.255                       
                                                  
                                                                                                    
# OpenStack Networking VXLAN (tunnel/overlay) bridge                                                
# The COMPUTE, NETWORK and INFRA nodes must have an IP address on this bridge.
                                                                                                    
auto br-vxlan
iface br-vxlan inet static
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp3s0.30
    address 172.29.240.90
    netmask 255.255.255.0

# OpenStack Networking VLAN bridge
auto br-vlan
iface br-vlan inet manual
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp3s0

# computes Storage bridge 
auto br-storage
iface br-storage inet static
    bridge_stp off
    bridge_waitport 0
    bridge_fd 0
    bridge_ports enp3s0.20
    address 172.29.244.90
    netmask 255.255.255.0
source /etc/network/interfaces.d/*.cfg
