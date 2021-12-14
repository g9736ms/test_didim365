#!/bin/bash

#방화벽 끄기
systemctl disable --now firewalld

# kubernetes 저장소 등록
gg_pkg="packages.cloud.google.com/yum/doc" # Due to shorten addr for key
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://${gg_pkg}/yum-key.gpg https://${gg_pkg}/rpm-package-key.gpg
EOF

# docker 저장소 등록
yum install yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# SELinux 설정
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# iptables 사용을 위한 설정
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
modprobe br_netfilter

# config DNS
cat <<EOF > /etc/resolv.conf
nameserver 1.1.1.1 #cloudflare DNS
nameserver 8.8.8.8 #Google DNS
EOF

# 필요한 패키지 설치
yum install epel-release -y
yum install vim-enhanced -y
yum install git -y
# docker 설치
yum install docker-ce-19.03.14-3.el7 docker-ce-cli-19.03.14-3.el7 containerd.io-1.3.9-3.1.el7 -y
# kubernetes 설치
yum install kubelet-1.22.2 kubectl-1.22.2 kubeadm-1.22.2 -y
# 데몬 등록 및 시작
systemctl enable --now docker
systemctl enable --now kubelet
