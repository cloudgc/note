#!/usr/bin/env bash

yum install openldap openldap-clients openldap-servers


yum install phpldapadmin


slappasswd

#{SSHA}awMR/Bpn+msA00urTyRWPKCXhDj/rWnQ


vi /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
