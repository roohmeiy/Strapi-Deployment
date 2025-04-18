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

# Create workspace directory
echo "Creating workspace directory..."
mkdir -p /home/ubuntu/strapi