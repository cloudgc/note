#!/usr/bin/env bash


#### /etc/pki/tls/openssl.cnf

#1. create ca

#create need dir
mkdir -pv ./ssl/{certs,crl,newcerts,private,CA}
touch ./ssl/{serial,index.txt}

# start serial no

echo 01 >> ./ssl/serial
#### create private rsa key
openssl genrsa -out ./ssl/private/cakey.pem 4096

#creeate ca
openssl req -new -x509 -key ./ssl/private/cakey.pem -sha256 -out ./ssl/CA/cacert.pem -days 356
openssl req -new -x509 -key ./cakey.pem -sha256 -out ./cacert.pem -days 356



openssl req -newkey rsa:2048 -nodes -keyout registry_auth.key -x509 -days 365 -out registry_auth.crt

###########################################################
###self ca
###########################################################

#create private-key
openssl genrsa -aes256 -passout "pass:cloud" -out ca-key.pem 4096
#create csr
openssl req -new -x509 -days 365 -key "ca-key.pem" -sha256 -out "ca.csr" -passin "pass:cloud" \
    -subj "/C=CN/ST=SH/L=SH/O=cloudfun.org/OU=cloudfun/CN=/emailAddress=cloudgc@126.com"

###create self signed ssl ca
openssl x509 -req -days 365 -sha256 -in "ca.csr" -passin "pass:cloud" -CA "ca.ca" -CAkey "ca-key.pem" \
    -CAcreateserial -out "ca.crt"

################################################

openssl genrsa -aes256 -passout "pass:cloud" -out cloud.key 4096

openssl req -new -days 365 -key cloud.key -out cloud.csr -passin "pass:cloud"  \
    -subj "/C=CN/ST=SH/L=SH/O=cloudfun.org/OU=cloudfun/CN=cloud/emailAddress=cloudgc@126.com"

openssl x509 -req -days 365 -sha256  -in cloud.csr  -passin "pass:cloud"  -signkey cloud.key  -out cloud.crt


update-ca-trust extract
