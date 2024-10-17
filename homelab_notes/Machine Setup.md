# Operating System
For this we will be using Ubuntu Server.
[Link](https://ubuntu.com/download/server)  to OS
# System Configs
1. Use minimised install. 
	- We will start with the minimum and expand from there.
2. Install: 
	- MikroK8s
	- Canonical Live Patch
	- Docker
3. Setup SSH
4. Run setup.sh script
	- `ssh user@host 'bash -s' < /path/to/setup.sh` 
5. Modify the hosts file to add hostnames of each node
	- `sudo nano /etc/hosts`
		- `sudo apt install nano`
	- Sample:
```
# k8s cluster nodes  
192.168.1.150 master.local master  
192.168.1.151 worker1.local worker1  
192.168.1.152 worker2.local worker2  
192.168.1.153 worker3.local worker3
```
6. Check that swap is commented out in `fstab`
	- `sudo nano /etc/fstab`
![[Pasted image 20241017204720.png]]
7. Reboot
	- `sudo reboot`
8. Confirm swap is off
	- `free -h`
# Kubernetes Install
## Master node
1. Run `master_node_setup.sh`
	- [[Control Plane notes]]
2. Get join command
	- `kubeadm token create --print-join-command`
3. Useful commands
	- `kubectl get nodes`
	- `kubectl get pods -n <kube_name_space>`
## Worker Node
1. Run the join command from the master node
2. Reboot
	- `sudo reboot`
