#!/usr/bin/env bash

cp kubernetes/server/bin/{kube-proxy,kubelet} /usr/local/bin/



wget https://download.docker.com/linux/static/stable/x86_64/docker-17.12.0-ce.tgz
tar -xvf docker-17.12.0-ce.tgz
cp docker/docker* /usr/local/bin

cat > docker.service << EOF
[Unit]
Description=Docker Application Container Engine
Documentation=http://docs.docker.io

[Service]
Environment="PATH=/usr/local/bin:/bin:/sbin:/usr/bin:/usr/sbin"
EnvironmentFile=-/run/flannel/subnet.env
EnvironmentFile=-/run/flannel/docker
ExecStart=/usr/local/bin/dockerd \\
  --exec-opt native.cgroupdriver=cgroupfs \\
  --log-level=error \\
  --log-driver=json-file \\
  --storage-driver=overlay \\
  \$DOCKER_NETWORK_OPTIONS
ExecReload=/bin/kill -s HUP \$MAINPID
Restart=on-failure
RestartSec=5
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Delegate=yes
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

cp docker.service /etc/systemd/system/docker.service

systemctl daemon-reload
systemctl enable docker
systemctl start docker
systemctl status docker

##master only
kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --user=kubelet-bootstrap



mkdir /var/lib/kubelet

cat > kubelet.service << EOF
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=docker.service
Requires=docker.service

[Service]
WorkingDirectory=/var/lib/kubelet
ExecStart=/usr/local/bin/kubelet \\
  --address=$HOST_IP \\
  --hostname-override=$HOST_IP \\
  --pod-infra-container-image=registry.access.redhat.com/rhel7/pod-infrastructure:latest \\
  --experimental-bootstrap-kubeconfig=/etc/kubernetes/bootstrap.kubeconfig \\
  --kubeconfig=/etc/kubernetes/kubelet.kubeconfig \\
  --require-kubeconfig \\
  --cert-dir=/etc/kubernetes/ssl \\
  --container-runtime=docker \\
  --cluster-dns=10.254.0.2 \\
  --cluster-domain=cluster.local \\
  --hairpin-mode promiscuous-bridge \\
  --allow-privileged=true \\
  --serialize-image-pulls=false \\
  --register-node=true \\
  --logtostderr=true \\
  --cgroup-driver=cgroupfs  \\
  --v=2

Restart=on-failure
KillMode=process
LimitNOFILE=65536
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

cp kubelet.service /etc/systemd/system/kubelet.service

systemctl daemon-reload
systemctl enable kubelet
systemctl start kubelet
systemctl status kubelet


##master

kubectl get csr

kubectl certificate approve ***

kubectl get nodes


cat > kube-proxy.service << EOF
[Unit]
Description=Kubernetes Kube-Proxy Server
Documentation=https://github.com/GoogleCloudPlatform/kubernetes
After=network.target

[Service]
WorkingDirectory=/var/lib/kube-proxy
ExecStart=/usr/local/bin/kube-proxy \\
  --bind-address=$HOST_IP \\
  --hostname-override=$HOST_IP \\
  --cluster-cidr=10.254.0.0/16 \\
  --kubeconfig=/etc/kubernetes/kube-proxy.kubeconfig \\
  --logtostderr=true \\
  --v=2
Restart=on-failure
RestartSec=5
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF


cp kube-proxy.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable kube-proxy
systemctl start kube-proxy
systemctl status kube-proxy


cd  /root/kube/master/kubernetes-master/cluster/addons/dns
sed -i 's/$DNS_SERVER_IP/10.254.0.2/g' ./kube-dns.yaml
sed -i 's/$DNS_DOMAIN/cluster.local/g' ./kube-dns.yaml

sed -i 's/$DNS_SERVER_IP/10.254.0.3/g' ./coredns.yaml
sed -i 's/$DNS_DOMAIN/cluster.local/g' ./coredns.yaml

systemctl status docker

docker pull k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3

docker save -o kube-dashboard 0c60bcf89900
docker load -i kube-dashboard
docker tag

kube_dashboar=`docker load -i kube-dashboard| awk -F ':' '{print $3 }'`
docker tag $kube_dashboar k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3

corndns_img=`docker load -i coredns.tar| awk -F ':' '{print $3 }'`
docker tag $corndns_img docker.io/coredns/coredns:1.0.6




get admin-key.pem
get admin.pem
get ca-key.pem
get ca.pem
get kubelet-client.crt
get kubelet-client.key
get kubelet.crt
get kubelet.key
get kube-proxy-key.pem
get kube-proxy.pem
get kubernetes-key.pem
get kubernetes.pem


kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml