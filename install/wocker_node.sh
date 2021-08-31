#!/bin/bash

ask(){
        echo "What is your master IP ? "
        read -p "[ex : 192.168.0.120] # " IP

        case $IP in
        *.*.*.*)
               echo ""
               echo ""
               echo "============"
               echo "set hostname"
               echo "============"
               read -p "What hostname will you use? " hostN
               hostnamectl set-hostname $hostN
               echo "$IP $hostN" >> /etc/hosts
               echo "echo $IP $hostN >> /etc/hosts" >> $PWD/master_node.sh
               echo "put it on master node"
               cat $PWD/master_node.sh
        ;;
        *)
                echo "The IP form is different. "
                ask
        ;;
        esac

      

}
ask
