#!/usr/bin/env bash


# echo 'admin,admin,1' > /etc/kubernetes/basic_auth_file
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


# curl --insecure https://vm1:6443 -basic -u admin:admin
# kubectl create clusterrolebinding  \
login-on-dashboard-with-cluster-admin  \
--clusterrole=cluster-admin --user=admin
# curl --insecure https://vm1:6443 -basic -u admin:admin
