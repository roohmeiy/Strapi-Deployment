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


USER_HOME="/home/ubuntu"
SSH_DIR="$USER_HOME/.ssh"

# Create SSH directory if not exists
mkdir -p "$SSH_DIR"

# Generate RSA key pair
ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/my-ec2-key" -N ""

# Set appropriate permissions
chmod 600 "$SSH_DIR/my-ec2-key"
chmod 644 "$SSH_DIR/my-ec2-key.pub"

# Add public key to authorized_keys
cat "$SSH_DIR/my-ec2-key.pub" >> "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"

# Ensure ownership is correct
chown -R ubuntu:ubuntu "$SSH_DIR"
✅