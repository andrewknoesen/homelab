#!/bin/bash

echo "Enter the control plane endpoint:"
read control_plane_endpoint

sudo kubeadm init --control-plane-endpoint="$control_plane_endpoint" --ignore-preflight-errors=all

# Copy /etc/kubernetes/admin.conf for using the node 
# as a Non-root user 
# Create .kube/config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico Network Plugin
# Currently (v3.25.0) is the latest, check the latest first for yours
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

