# Use default VPC and subnet
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
# Security group
resource "aws_security_group" "strapi__sg" {
  name        = "strapi-security-group-new"
  description = "Security group for Strapi application"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "payal-rsa"
  public_key = file("${path.module}/payal-rsa.pub")
}

resource "aws_instance" "strapi_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name 
  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.strapi__sg.id]

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "payal-strapi-server"
  }

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = false
  }
}

# resource "aws_ecr_repository" "strapi_app" {
#   name                 = var.ecr_repository_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }