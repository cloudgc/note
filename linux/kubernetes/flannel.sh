#!/usr/bin/env bash
mkdir flannel
tar -xzvf flannel-v0.9.1-linux-amd64.tar.gz -C flannel
cp flannel/{flanneld,mk-docker-opts.sh} /usr/local/bin

etcdctl --endpoints=https://192.168.1.113:2379,https://192.168.1.113:2379 \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mkdir /kubernetes/network

etcdctl --endpoints=https://192.168.1.113:2379,https://192.168.1.113:2379 \
  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  mk /kubernetes/network/config '{"Network":"172.30.0.0/16","SubnetLen":24,"Backend":{"Type":"vxlan"}}'


cat > flanneld.service << EOF
[Unit]
Description=Flanneld overlay address etcd agent
After=network.target
After=network-online.target
Wants=network-online.target
After=etcd.service
Before=docker.service

[Service]
Type=notify
ExecStart=/usr/local/bin/flanneld \\
  -etcd-cafile=/etc/kubernetes/ssl/ca.pem \\
  -etcd-certfile=/etc/kubernetes/ssl/kubernetes.pem \\
  -etcd-keyfile=/etc/kubernetes/ssl/kubernetes-key.pem \\
  -etcd-endpoints=https://192.168.1.113:2379,https://192.168.1.113:2379 \\
  -etcd-prefix=/kubernetes/network
ExecStartPost=/usr/local/bin/mk-docker-opts.sh -k DOCKER_NETWORK_OPTIONS -d /run/flannel/docker
Restart=on-failure

[Install]
WantedBy=multi-user.target
RequiredBy=docker.service
EOF


cp flanneld.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable flanneld
systemctl start flanneld
systemctl status flanneld


etcdctl  --ca-file=/etc/kubernetes/ssl/ca.pem \
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \
  ls /kubernetes/network/subnets

