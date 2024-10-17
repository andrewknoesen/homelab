#!/bin/bash

# Set hostname for each machine
echo "Enter the desired hostname:"
read new_hostname

sudo hostnamectl set-hostname "${new_hostname}.local"
echo "Hostname set to ${new_hostname}.local"
exec bash

# Apply any updates and reboot (*)
sudo apt update
sudo apt upgrade
sudo reboot

# Disable swap for better performance
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Add settings to containerd.conf
# overlay (for using overlayfs), 
# br_netfilter (for ipvlan, macvlan, external SNAT of service IPs)
sudo tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# Add settings to kubernetes.conf
# Allow IPv4, IPv6 and IP forwarding
sudo tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

# Reload updated config
sudo sysctl --system

# Install required tools and CA certificates
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Add Docker repository
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Then, install containerd
sudo apt update
sudo apt install -y containerd.io
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Add Kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/kubernetes-xenial.gpg
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

# Then, install Kubernetes components
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Open TCP port for K8s API (default 6443)
sudo iptables -A INPUT -p tcp --dport 6443 -j ACCET
