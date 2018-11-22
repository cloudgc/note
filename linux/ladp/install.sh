#!/usr/bin/env bash

yum install openldap openldap-clients openldap-servers


yum install phpldapadmin


slappasswd

#{SSHA}awMR/Bpn+msA00urTyRWPKCXhDj/rWnQ


vi /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{2\}hdb.ldif
#修改内容：
#olcSuffix: dc=domian,dc=com
#olcRootDN: cn=root,dc=domian,dc=com
#添加内容：
#olcRootPW: {SSHA}awMR/Bpn+msA00urTyRWPKCXhDj/rWnQ

vi /etc/openldap/slapd.d/cn\=config/olcDatabase\=\{1\}monitor.ldif

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap:ldap -R /var/lib/ldap
chmod 700 -R /var/lib/ldap

slaptest -u

service slapd start


ldapsearch -x -b '' -s base'(objectclass=*)'

ldapadd -x -D "cn=admin,dc=cloudfun,dc=org" -W -f admin.ldif


vi /etc/httpd/conf.d/phpldapadmin.conf
#Require all granted
#Require ip 192.168.1.1

vim /etc/phpldapadmin/config.php
#$servers->setValue('login','anon_bind',false);

#$servers->setValue('login','allowed_dns',array('cn=admin,dc=cloudfun,dc=org'));
#$servers->setValue('login','attr','dn');
#//$servers->setValue('login','attr','uid')

ldapadd -x -D "cn=admin,dc=cloudfun,dc=org" -W -f admin.ldif

ldapadd -x -D cn=admin,dc=cloudfun,dc=org -W -f join.ldif
ldapmodify -x -D cn=admin,dc=cloudfun,dc=org -W -f join.ldif


ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=config dn

ldapsearch -x -LLL -H ldap:/// -b dc=cloudfun,dc=org dn


ldapsearch -x -LLL -b dc=example,dc=com 'uid=john' cn gidNumber

#======dbconfig

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f uid_index.ldif

ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b  cn=config '(olcDatabase={2}hdb)' olcDbIndex

ldapsearch -Q -LLL -Y EXTERNAL -H ldapi:/// -b cn=schema,cn=config dn


slapcat -f schema_convert.conf -F ldif_output -n 0 | grep corba,cn=schema


openssl req -new -x509 -nodes -out /etc/openldap/certs/myldap.field.linuxhostsupport.com.cert \
-keyout /etc/openldap/certs/myldap.field.linuxhostsupport.com.key \
-days 365






#================install
yum -y install openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel
rpm -e --nodeps openldap compat-openldap openldap-clients openldap-servers openldap-servers-sql openldap-devel
yum remove -y  phpldapadmin