#!/bin/bash

read -p "What is your master IP ? " IP
#쿠버 네트워크랑 실 네트워크랑 대역폭이 겹치면 안됨
# kubeadm init --token $(사용할토큰) --token-ttl 0 --pod-network-cidr=$(IP/cider) --apiserver-advertise-address=$(컨트롤플레인IP)
sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$IP > /root/kubeinit.txt

#아래는 kubeadm init 정상 완료시 나오는 내용들 입니다.
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

#칼리코 퀵스타트()
kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
#여기 부분에서 init한 대역폭이롱 똑같이 수정해서 실행 시켜줘야함.
kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml 
#watch kubectl get pods -n calico-system
