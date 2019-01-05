#!/usr/bin/env bash

#$ curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
#$ cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
#deb http://apt.kubernetes.io/ kubernetes-xenial main
#EOF
#$ apt-get update
#$ apt-get install -y docker.io kubeadm


cat << EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
gpgcheck=0
enable=1
EOF

wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -O /etc/yum.repos.d/docker-ce.repo

yum clean all

yum repolist


#kubelet、kubectl、kubernetes-cni
yum install  kubelet  kubeadm  kubectl  kubernetes-cni
#yum install  kubelet-1.12.2  kubeadm-1.12.2  kubectl-1.12.2  kubernetes-cni
#systemctl enable docker
#systemctl start docker

#yum remove kubelet  kubeadm  kubectl  kubernetes-cni
#yum remove  kubelet-1.12.0  kubeadm-1.12.0  kubectl-1.12.0  kubernetes-cni

kubeadm init --config kube.yaml
#kubeadm config migrate --old-config kubeadm.yaml --new-config kubeadm-new.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


kubectl get nodes

kubectl describe node master

##
kubectl get pods -n kube-system

kubectl apply -f https://git.io/weave-kube-1.6

#$ kubectl taint nodes node1 foo=bar:NoSchedule
#$ kubectl taint nodes --all node-role.kubernetes.io/master-


#kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
#kubectl proxy --address="0.0.0.0" -p 8001 --accept-hosts='^*$'
kubectl proxy --address="172.16.189.224" -p 8001 --accept-hosts='^*$'

kubectl -n kube-system get secret

#kubectl describe pod/kubernetes-dashboard-65c76f6c97-6cz9v -n kube-system

kubectl delete replicasets/kubernetes-dashboard -n kube-system
kubectl delete svc/kubernetes-dashboard -n kube-system
kubectl delete deployments/kubernetes-dashboard -n kube-system
kubectl -n kube-system delete $(kubectl -n kube-system get pod -o name | grep dashboard)
kubectl -n kube-system delete clusterrolebindings  kubernetes-dashboard-minimal
kubectl -n kube-system delete clusterrolebindings  kubernetes-dashboar
kubectl delete role kubernetes-dashboard-minimal -n kube-system
kubectl delete serviceaccounts -n kube-system kubernetes-dashboard



kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep kubernetes-dashboard | awk '{print $1}')


kubectl -n kube-system describe secret replicaset-controller-token-kzpmc


# echo 'admin,cloud,1' > /etc/kubernetes/basic_auth_file
# grep 'auth' /usr/lib/systemd/system/kube-apiserver.service
  --authorization-mode=Node,RBAC \
  --runtime-config=rbac.authorization.k8s.io/v1alpha1 \
  --enable-bootstrap-token-auth=true \
  --token-auth-file=/etc/kubernetes/token.csv \
  --basic-auth-file=/etc/kubernetes/basic_auth_file \

# grep  ‘basic’  k8s-dashborad-deployment.yaml   （配置在args下面）
     - --authentication-mode=basic

# systemctl daemon-reload
# systemctl restart kube-apiserver
# kubectl apply -f k8s-dashborad-deployment.yaml
