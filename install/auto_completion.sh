#!/bin/bash
# install bash-completion for kubectl 
yum install bash-completion -y 

alias k=kubectl
complete -F __start_kubectl k

# kubectl completion on bash-completion dir
kubectl completion bash >/etc/bash_completion.d/kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc

# alias kubectl to k 
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc

source /usr/share/bash-completion/bash_completion
