#!/bin/bash

# Set hostname for each machine
echo "Enter the desired hostname:"
read new_hostname

sudo hostnamectl set-hostname "${new_hostname}.local"
echo "Hostname set to ${new_hostname}.local"

# Apply any updates and reboot (*)
sudo apt update
sudo apt upgrade
sudo reboot
