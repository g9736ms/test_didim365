#!/bin/bash

ask(){
        echo "What is your worker-node IP ? "
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
               echo ""
               echo "============================================"
               echo "put it on other node"
               cat $PWD/master_node.sh
               echo "============================================"
               echo ""
        ;;
        *)
                echo "The IP form is different. "
                ask
        ;;
        esac

      

}
ask
