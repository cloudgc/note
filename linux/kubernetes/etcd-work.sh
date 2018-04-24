#!/usr/bin/env bash

tar -xvf etcd-v3.2.12-linux-amd64.tar.gz
mv etcd-v3.2.12-linux-amd64/etcd* /usr/local/bin
#创建工作目录
mkdir -p /var/lib/etcd

echo "HOSTNAME=wk" >> /etc/profile
echo "HOST_IP=192.168.1.115" >> /etc/profile

echo "HOST_LIST=https://192.168.1.113:2380,wk=https://192.168.1.115:2380" >> /etc/profile

source /etc/profile

cat > etcd.service << EOF
[Unit]
Description=Etcd Server
After=network.target
After=network-online.target
Wants=network-online.target
Documentation=https://github.com/coreos

[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
ExecStart=/usr/local/bin/etcd \\
  --name $HOSTNAME \\
  --cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --peer-cert-file=/etc/kubernetes/ssl/kubernetes.pem \\
  --peer-key-file=/etc/kubernetes/ssl/kubernetes-key.pem \\
  --trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \\
  --initial-advertise-peer-urls https://$HOST_IP:2380 \\
  --listen-peer-urls https://$HOST_IP:2380 \\
  --listen-client-urls https://$HOST_IP:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls https://$HOST_IP:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster $HOST_LIST \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


sudo cp etcd.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
systemctl status etcd

systemctl stop etcd
