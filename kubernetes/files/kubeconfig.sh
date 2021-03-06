#!/bin/bash

# server url
server="$(cat /etc/kubernetes/kubelet.kubeconfig  | grep server | awk '{ print $2 }')"

# certificates
cert="$(cat /etc/kubernetes/ssl/kubelet-client.crt | base64 | sed 's/^/      /g')"
key="$(cat /etc/kubernetes/ssl/kubelet-client.key | base64 | sed 's/^/      /g')"
ca="$(cat /etc/kubernetes/ssl/ca-kubernetes.crt | base64 | sed 's/^/      /g')"

echo "apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: |
${ca}
    server: ${server}
  name: mycluster
- cluster:
    server: http://localhost:8080
  name: local
contexts:
- context:
    cluster: mycluster
    user: "cluster-admin"
  name: mycluster
- context:
    cluster: local
    namespace: default
    user: ""
  name: local
current-context: mycluster
users:
- name: cluster-admin
  user:
    client-certificate-data: |
${cert}
    client-key-data: |
${key}
kind: Config
preferences: {}"
