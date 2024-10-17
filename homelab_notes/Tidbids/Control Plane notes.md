For a setup with 1 master and 2 worker nodes, it's generally fine to set the control-plane-endpoint to the IP address or hostname of your master node. However, there are some considerations to keep in mind:

1. Single Point of Failure: With only one master node, your control plane becomes a single point of failure. If the master node goes down, you won't be able to manage your cluster until it's restored [1](https://sysdig.com/learn-cloud-native/components-of-kubernetes/) .
2. Future Scalability: If you plan to scale to a highly available setup in the future, it's recommended to use a separate control-plane-endpoint (like a load balancer or round-robin DNS) from the beginning. Changing this later is not supported by kubeadm [4](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
3. Certificate Generation: The control-plane-endpoint is used in generating certificates for the API server. These certificates need to match the address that clients use to access the API server [3](https://stackoverflow.com/questions/57845534/why-is-kubeadm-configs-controlplaneendpoint-necessary).

Given your current setup, here's what you can do:

1. If you don't plan to scale to multiple masters soon, you can use the master node's IP or hostname as the control-plane-endpoint:
`sudo kubeadm init --control-plane-endpoint=<master-ip-or-hostname> --pod-network-cidr=10.244.0.0/16`
2. If you might scale to multiple masters in the future, consider setting up a DNS name that currently points to your master node, but could later be changed to point to a load balancer:
`sudo kubeadm init --control-plane-endpoint=<dns-name> --pod-network-cidr=10.244.0.0/16`
Remember, the control-plane-endpoint should be reachable by all nodes in the cluster [1](https://sysdig.com/learn-cloud-native/components-of-kubernetes/).Lastly, while this setup will work, for production environments it's generally recommended to have at least 3 master nodes for high availability. This ensures that your cluster remains manageable even if one master node fails [1](https://sysdig.com/learn-cloud-native/components-of-kubernetes/)[5](https://www.keitaro.com/insights/2021/09/03/setting-up-a-kubernetes-on-premise-cluster-with-kubeadm/).