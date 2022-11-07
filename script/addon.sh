ansible -i /ip.txt -m shell -a "ifdown enp2s0" all 
ansible -i /ip.txt -m shell -a "route add default gw 192.168.122.1 enp1s0"  all 
ansible -i /ip.txt -m shell -a "route -n"  all 
ansible -i /ip.txt -m shell -a "ping google.com -c1"  all 
