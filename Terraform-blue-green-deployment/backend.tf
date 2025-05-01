terraform {
  backend "s3" {
    bucket = "payal--strapi-bucket"
    key    = "terraform/state"
    region = "us-east-1"
    encrypt = true
  }
}