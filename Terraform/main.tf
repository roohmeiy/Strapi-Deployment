# Specify the AWS region
provider "aws" {
  region = var.aws_region
}

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

# Define the AWS S3 backend for remote state management with DynamoDB for state locking
terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name                  
    key            = "terraform.tfstate"                    
    region         = var.aws_region
    dynamodb_table = var.dynamodb_table_name              
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform_state_lock"
  }
}

# Security group
resource "aws_security_group" "strapi__sg" {
  name        = "strapi-security-group-new"
  description = "Security group for Strapi application"
  vpc_id      = data.aws_vpc.default.id

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

# IAM role for SSM
resource "aws_iam_role" "ssm_role" {
  name               = "ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

# EC2 Instance
resource "aws_instance" "strapi_instance" {
  ami                    = var.ami_id
  instance_type         = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ssm_profile.id
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

# IAM Instance Profile for the SSM role
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

# Create ECR Repository
resource "aws_ecr_repository" "strapi_app" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}