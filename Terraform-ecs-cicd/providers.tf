provider "aws" {
  region = var.aws_region
  profile = "default"
}

terraform {
    required_version = "1.11.3"
}
