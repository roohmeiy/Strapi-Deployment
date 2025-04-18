#!/bin/bash
sudo apt-get update
sudo apt-get upgrade -y

# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add the ec2-user to the docker group (for non-root access)
sudo usermod -aG docker $USER

# Make sure Docker is started
sudo service docker start

# Pull and run the Docker image
$(aws ecr get-login --no-include-email --region ${var.aws_region})
docker run -d \
--name strapi \
-p 1337:1337 \
${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/strapi:${var.image_tag}