#!/usr/bin/env bash


##create workdir
if [ ! -d "/usr/local/bin" ];then
    echo "/usr/local/bin not exit"
    exit -1
fi


cp  ./cfssl /usr/local/bin/cfssl
chmod a+x /usr/local/bin/cfssl
cp ./cfssljson /usr/local/bin/cfssljson
chmod a+x /usr/local/bin/cfssljson
cp ./cfssl-certinfo /usr/local/bin/cfssl-certinfo
chmod a+x /usr/local/bin/cfssl-certinfo

mkdir ./ssl
cd ./ssl
#创建 CA 配置文件
#ca-config.json：可以定义多个 profiles，分别指定不同的过期时间、使用场景等参数；后续在签名证书时使用某个 profile；
#signing：表示该证书可用于签名其它证书；生成的 ca.pem 证书中 CA=TRUE；
#server auth：表示 client 可以用该 CA 对 server 提供的证书进行验证；
#client auth：表示 server 可以用该 CA 对 client 提供的证书进行验证；
cat > ca-config.json << EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing",
            "key encipherment",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
EOF
#创建 CA 证书签名请求：
#“CN”：Common Name，kube-apiserver 从证书中提取该字段作为请求的用户名 (User Name)；浏览器使用该字段验证网站是否合法；
#“O”：Organization，kube-apiserver 从证书中提取该字段作为请求用户所属的组 (Group)；
cat > ca-csr.json << EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ShangHai",
      "L": "ShangHai",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF

#生成 CA 证书和私钥
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
#创建 kubernetes 证书签名请求文件：
#hosts 中的内容可以为空，即使按照下面的配置，向集群中增加新节点后也不需要重新生成证书。
#如果 hosts 字段不为空则需要指定授权使用该证书的 IP 或域名列表，
# 由于该证书后续被 etcd 集群和 kubernetes master 集群使用，
# 所以下面分别指定了 etcd 集群、kubernetes master 集群的主机 IP 和 kubernetes 服务的服务 IP

cat > kubernetes-csr.json << EOF
{
   "CN": "kubernetes",
    "hosts": [
      "127.0.0.1",
      "192.168.1.113",
      "192.168.1.115",
      "10.254.0.1",
      "kubernetes",
      "kubernetes.default",
      "kubernetes.default.svc",
      "kubernetes.default.svc.cluster",
      "kubernetes.default.svc.cluster.local"
    ],
    "key": {
        "algo": "rsa",
        "size": 2048
    },
    "names": [
        {
            "C": "CN",
            "ST": "ShangHai",
            "L": "ShangHai",
            "O": "k8s",
            "OU": "System"
        }
    ]
}
EOF

#生成 kubernetes 证书和私钥
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

#创建 admin 证书
cat > admin-csr.json << EOF
{
  "CN": "admin",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ShangHai",
      "L": "ShangHai",
      "O": "system:masters",
      "OU": "System"
    }
  ]
}
EOF

#kube-apiserver 使用 RBAC 对客户端(如 kubelet、kube-proxy、Pod)请求进行授权；
#kube-apiserver 预定义了一些 RBAC 使用的 RoleBindings，
# 如 cluster-admin 将 Group system:masters 与 Role cluster-admin 绑定，该 Role 授予了调用kube-apiserver 的所有 API的权限；
#OU 指定该证书的 Group 为 system:masters，kubelet 使用该证书访问 kube-apiserver 时 ，由于证书被 CA 签名，所以认证通过，
# 同时由于证书用户组为经过预授权的 system:masters，所以被授予访问所有 API 的权限

cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin

#创建 kube-proxy 证书
#CN 指定该证书的 User 为 system:kube-proxy；
#kube-apiserver 预定义的 RoleBinding cluster-admin 将User system:kube-proxy 与 Role system:node-proxier 绑定，
# 该 Role 授予了调用 kube-apiserver Proxy 相关 API 的权限；

cat > kube-proxy-csr.json << EOF
{
  "CN": "system:kube-proxy",
  "hosts": [],
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "ShangHai",
      "L": "ShangHai",
      "O": "k8s",
      "OU": "System"
    }
  ]
}
EOF
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=kubernetes  kube-proxy-csr.json | cfssljson -bare kube-proxy

#分发证书

if [ ! -d "/etc/kubernetes/ssl" ];then
    mkdir -p /etc/kubernetes/ssl
fi

cp *.pem /etc/kubernetes/ssl

cd ../

ls /etc/kubernetes/ssl/

#scp *.pem wk:/etc/kubernetes/ssl