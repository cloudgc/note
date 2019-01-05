#!/usr/bin/env bash

docker pull k8s.gcr.io/kubernetes-dashboard-arm64:v1.10.1
docker pull k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1
docker pull k8s.gcr.io/kubernetes-dashboard-ppc64le:v1.10.1
docker pull k8s.gcr.io/kubernetes-dashboard-arm:v1.10.1
docker pull k8s.gcr.io/kubernetes-dashboard-s390x:v1.10.1



docker tag k8s.gcr.io/kubernetes-dashboard-arm64:v1.10.1       cloudfun/kubernetes-dashboard-arm64:v1.10.1
docker tag k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1       cloudfun/kubernetes-dashboard-amd64:v1.10.1
docker tag k8s.gcr.io/kubernetes-dashboard-ppc64le:v1.10.1       cloudfun/kubernetes-dashboard-ppc64le:v1.10.1
docker tag k8s.gcr.io/kubernetes-dashboard-arm:v1.10.1       cloudfun/kubernetes-dashboard-arm:v1.10.1
docker tag k8s.gcr.io/kubernetes-dashboard-s390x:v1.10.1       cloudfun/kubernetes-dashboard-s390x:v1.10.1

docker push    cloudfun/kubernetes-dashboard-arm64:v1.10.1
docker push    cloudfun/kubernetes-dashboard-amd64:v1.10.1
docker push    cloudfun/kubernetes-dashboard-ppc64le:v1.10.1
docker push    cloudfun/kubernetes-dashboard-arm:v1.10.1
docker push    cloudfun/kubernetes-dashboard-s390x:v1.10.1



docker pull cloudfun/kubernetes-dashboard-arm64:v1.10.1
docker pull cloudfun/kubernetes-dashboard-amd64:v1.10.1
docker pull cloudfun/kubernetes-dashboard-ppc64le:v1.10.1
docker pull cloudfun/kubernetes-dashboard-arm:v1.10.1
docker pull cloudfun/kubernetes-dashboard-s390x:v1.10.1


docker tag   cloudfun/kubernetes-dashboard-arm64:v1.10.1   k8s.gcr.io/kubernetes-dashboard-arm64:v1.10.1
docker tag   cloudfun/kubernetes-dashboard-amd64:v1.10.1   k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1
docker tag   cloudfun/kubernetes-dashboard-ppc64le:v1.10.1 k8s.gcr.io/kubernetes-dashboard-ppc64le:v1.10.1
docker tag   cloudfun/kubernetes-dashboard-arm:v1.10.1     k8s.gcr.io/kubernetes-dashboard-arm:v1.10.1
docker tag   cloudfun/kubernetes-dashboard-s390x:v1.10.1   k8s.gcr.io/kubernetes-dashboard-s390x:v1.10.1

docker rmi  cloudfun/kubernetes-dashboard-arm64:v1.10.1
docker rmi  cloudfun/kubernetes-dashboard-amd64:v1.10.1
docker rmi  cloudfun/kubernetes-dashboard-ppc64le:v1.10.1
docker rmi  cloudfun/kubernetes-dashboard-arm:v1.10.1
docker rmi  cloudfun/kubernetes-dashboard-s390x:v1.10.1