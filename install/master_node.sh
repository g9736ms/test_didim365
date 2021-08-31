#!/bin/bash

check_status(){
	if [ "$?" == "0" ]; then
		echo "complete"
	else
		echo "creation failed"
	fi
}

ask(){
	#init에서 쓸 IP 
	echo "What is your master IP ? "
	read -p "[ex : 192.168.0.120] # " IP

	case $IP in
        *.*.*.*)
                mk_master
        ;;
        *)
                echo "The IP form is different. "
                ask
        ;;
	esac
	
	echo ""
	echo ""
	echo "============"
	echo "set hostname"
	echo "============"
	#hostIP를 물어보고 /etc/hosts 추가 시켜준다
  #그리고 워커노드에서 실행 시켜주면 될 파일을 만들어 주면 될듯
	read -p "What hostname will you use? " hostN
	hostnamectl set-hostname $hostN
	echo "$IP $hostN" >> /etc/hosts
	echo "echo $IP $hostN >> /etc/hosts" >> /root/test_didim365/install/wocker_node.sh
	#init 으로 나온 파일 열어서 워커노드에 필요한 부분만 잘라서 붙여 넣기 하면됨 
	cat kubeinit.txt |tail -n 2 >> /root/test_didim365/install/wocker_node.sh
}

mk_master(){
	echo ""
	echo ""
	echo "================================"
	echo "set kubeadm , wait a few minite"
	echo "================================"
	#쿠버 네트워크랑 실 네트워크랑 대역폭이 겹치면 안됨
	# kubeadm init --token $(사용할토큰) --token-ttl 0 --pod-network-cidr=$(IP/cider) --apiserver-advertise-address=$(컨트롤플레인IP)
	sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$IP > /root/kubeinit.txt
	check_status
	echo "Execution contents can be checked in /root/kubeinit.txt "
	
	#아래는 kubeadm init 정상 완료시 나오는 내용들 입니다.
	mkdir -p $HOME/.kube
	sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
	sudo chown $(id -u):$(id -g) $HOME/.kube/config

	export KUBECONFIG=/etc/kubernetes/admin.conf
}

mk_cni(){
	echo ""
	echo "================"
	echo "set CNI (calico)"
	echo "================"
	#칼리코 퀵스타트()
	kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml > /dev/null
	#여기 부분에서 init한 대역폭이롱 똑같이 수정해서 실행 시켜줘야함.
	kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml > /dev/null
	#watch kubectl get pods -n calico-system
	check_status
	echo "[kubectl get pods -n calico-system] It can be checked."
}

ask
mk_cni
echo ""
echo ""
echo "============================================="
echo "======= Apply it to your workernodes. ======="
echo "============================================="
cat ~/wocker_node.sh

