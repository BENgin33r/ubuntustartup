#!/bin/bash

# Mount disk vdb
sudo mkfs.ext4 /dev/vdb
sudo mkdir /mnt/vdb
sudo mount /dev/vdb /mnt/vdb

# Create user ubuntu and assign sudo privileges
sudo useradd -m -d /mnt/vdb/ubuntu -s /bin/bash ubuntu
echo "ubuntu ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ubuntu

# Get the UUID of disk vdb
UUID=$(sudo blkid -s UUID -o value /dev/vdb)

# Edit /etc/fstab to make the mount persistent
echo "UUID=$UUID /mnt/vdb ext4 defaults 0 0" | sudo tee -a /etc/fstab

# Change the user ubuntu default directory to disk vdb
sudo usermod -d /mnt/vdb/ubuntu ubuntu

# Ensure the mount is active
sudo mount -a
# Give user ubuntu read and write privileges to /mnt/vdb
sudo chown -R ubuntu:ubuntu /mnt/vdb
sudo chmod -R 755 /mnt/vdb

# Create .ssh directory for user ubuntu
sudo mkdir -p /mnt/vdb/ubuntu/.ssh
sudo chmod 700 /mnt/vdb/ubuntu/.ssh

# Add the public key to authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsIq8PKQSEs+ZVTZnHoVi8vhpsS3jlELiWcY13kFtM6" | sudo tee /mnt/vdb/ubuntu/.ssh/authorized_keys
sudo chmod 600 /mnt/vdb/ubuntu/.ssh/authorized_keys
sudo chown -R ubuntu:ubuntu /mnt/vdb/ubuntu/.ssh


# Setup server with required applications
sudo apt update && sudo apt upgrade -y
sudo apt install -y git python3 python3-pip python-is-python3 git-lfs
sudo apt install nvtop
sudo apt install htop -y
sudo apt install python3.10-venv -y
sudo apt install nginx nginx-extras -y
sudo apt-get install curl
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 

# Install pm2 globally using npm
nvm install 20
npm i pm2 -g

sudo reboot
