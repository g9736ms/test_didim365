#!/bin/bash


check_status(){
	if [ "$?" == "0" ]; then
		echo "complete"
	else
		echo "creation failed"
	fi
}

ask(){
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
	read -p "What hostname will you use? " hostN
	hostnamectl set-hostname $hostN
	echo "$IP $hostN" >> /etc/hosts
	echo "echo $IP $hostN >> /etc/hosts" >> $PWD/wocker_node.sh
	cat $PWD/kubeinit.txt |tail -n 2 >> $PWD/wocker_node.sh
}

mk_master(){
	echo ""
	echo ""
	echo "================================"
	echo "set kubeadm , wait a few minite"
	echo "================================"
	
	sudo kubeadm init --token 123456.1234567890123456 --token-ttl 0 --pod-network-cidr=192.168.0.0/16 --apiserver-advertise-address=$IP > $PWD/kubeinit.txt
	check_status
	echo "Execution contents can be checked in $PWD/kubeinit.txt "
	
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
	
	kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml > /dev/null
	kubectl create -f https://docs.projectcalico.org/manifests/custom-resources.yaml > /dev/null
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
cat $PWD/wocker_node.sh

