#!/bin/bash
source /root/admin-openrc
openstack network create  --share --external --provider-physical-network pyth1 --provider-network-type flat flat-test
openstack subnet create --network flat-test  --allocation-pool start=192.168.147.80,end=192.168.147.90  --dns-nameserver 192.168.147.2 --gateway 192.168.147.2   --subnet-range 192.168.147.0/24 flat-test-subnet
openstack flavor create --id 0 --vcpus 1 --ram 256 --disk 1 m1.nano  
source /root/demo-openrc
ssh-keygen  -f /root/.ssh/id_rsa -q -N ""  
openstack keypair create --public-key ~/.ssh/id_rsa.pub mykey
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
source /root/admin-openrc
netid=$(openstack network list|tail -n 2|head -n 1|awk -F ' ' {'print $2'})
source /root/demo-openrc
openstack server create --flavor m1.nano --image cirros --nic net-id=$netid --security-group default --key-name mykey queens-instance
