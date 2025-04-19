#!/bin/bash

# Update system
echo "Updating system packages..."
apt-get update

echo "Installing Docker..."
apt-get install -y docker.io

apt-get install -y git vim curl wget build-essential

# Start and enable Docker
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
echo "Adding ubuntu user to docker group..."
usermod -aG docker ubuntu

#!/bin/bash

# Update system
echo "Updating system packages..."
apt-get update

echo "Installing Docker..."
apt-get install -y docker.io

apt-get install -y git vim curl wget build-essential

# Start and enable Docker
echo "Starting Docker service..."
systemctl start docker
systemctl enable docker

# Add ubuntu user to docker group
echo "Adding ubuntu user to docker group..."
usermod -aG docker ubuntu

mkdir -p ~/.ssh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/my-ec2-key -N ""

chmod 600 ~/.ssh/my-ec2-key
chmod 644 ~/.ssh/my-ec2-key.pub

cat ~/.ssh/my-ec2-key.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
