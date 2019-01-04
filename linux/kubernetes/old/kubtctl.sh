#!/usr/bin/env bash
tar -xzvf kubernetes-client-linux-amd64.tar.gz

sudo cp kubernetes/client/bin/kube* /usr/local/bin/
chmod a+x /usr/local/bin/kube*
export PATH=/root/local/bin:$PATH
