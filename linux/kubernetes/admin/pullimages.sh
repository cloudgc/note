#!/bin/bash
#images=(kube-proxy-amd64:v1.11.1 kube-scheduler-amd64:v1.11.1 kube-controller-manager-amd64:v1.11.1
#kube-apiserver-amd64:v1.11.1 etcd-amd64:3.2.18 coredns:1.1.3 pause:3.1 )
#for imageName in ${images[@]} ; do
#docker pull anjia0532/google-containers.$imageName
#docker tag anjia0532/google-containers.$imageName $imageName
#docker rmi anjia0532/google-containers.$imageName
#done

images_k8s=(kube-proxy:v1.12.2 kube-apiserver:v1.12.2 kube-controller-manager:v1.12.2 kube-scheduler:v1.12.2 etcd:3.2.24 coredns:1.2.2 pause:3.1 )

images_k8s=(kube-proxy:v1.14.1 kube-apiserver:v1.14.1 kube-controller-manager:v1.14.1 kube-scheduler:v1.14.1 etcd:3.3.10 coredns:1.3.1 pause:3.1 )

for imageName in ${images_k8s[@]} ; do
    docker pull cloudfun/$imageName
    docker tag cloudfun/$imageName k8s.gcr.io/$imageName
    docker rmi cloudfun/$imageName
done



#kubeadm join 47.99.111.155:8103 --token 9bq7de.any36nzob1kmqnpl --discovery-token-ca-cert-hash sha256:e6236d23f9a7bbeeed8b8be08b85da1a4824f21ac69a9940bb515d7904e042fa

