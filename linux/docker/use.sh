#!/usr/bin/env bash

###create network
docker  network create -d bridge --subnet=10.1.0.0/16 --gateway=10.1.0.254 \
    --attachable --opt encrypted=true inner-bridge

### create dns

docker run -d -p 53:53/tcp -p 53:53/udp --cap-add=NET_ADMIN --restart=always --name dns-server andyshinn/dnsmasq


docker run -d   --restart=always --name httpd --network=inner-bridge  httpd
docker run -dti   --name busybox  --network=inner-bridge --hostname busybox  busybox


docker run -d -p 80:80 --restart=always --name nginx --network=inner-bridge --hostname nginx   nginx