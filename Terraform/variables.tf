variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "The instance type for the EC2 instance."
  default     = "t2.micro"  # Default can be overridden
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for the Terraform state."
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy resources."
  type        = string
  default     = "us-east-1"  # Default can be overridden
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking."
  type        = string
}
variable "ecr_repository_name" {
    description = "Name of ecr repo"
    type = string  
}