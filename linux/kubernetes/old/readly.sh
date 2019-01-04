#!/usr/bin/env bash

# /etc/fstab
swapoff -a

systemctl stop firewalld
systemctl disable firewalld

cat << EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF


modprobe br_netfilter
echo "modprobe br_netfilter" >> /etc/rc.local


sysctl -p /etc/sysctl.d/k8s.conf
setenforce 0

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

/sbin/iptables -P FORWARD ACCEPT
echo  "sleep 60 && /sbin/iptables -P FORWARD ACCEPT" >> /etc/rc.local

docker