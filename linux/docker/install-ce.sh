#!/usr/bin/env bash


mkdir docker && cd ./docker

wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm

yum install -y  docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
#
#
#wget ftp://mirror.switch.ch/pool/4/mirror/centos/7.5.1804/extras/x86_64/Packages/container-selinux-2.55-1.el7.noarch.rpm
#
#
#wget ftp://mirror.switch.ch/pool/4/mirror/centos/7.5.1804/os/x86_64/Packages/policycoreutils-python-2.5-22.el7.x86_64.rpm
#
#wget ftp://mirror.switch.ch/pool/4/mirror/centos/7.5.1804/os/x86_64/Packages/selinux-policy-3.13.1-192.el7.noarch.rpm

#gpasswd -a user docker
