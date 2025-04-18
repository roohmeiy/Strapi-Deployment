# Outputs
output "public_ip" {
  value = aws_instance.strapi_instance.public_ip
}

output "strapi_url" {
  value = "http://${aws_instance.strapi_instance.public_ip}:1337"
}