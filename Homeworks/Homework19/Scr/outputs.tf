output "public_ec2_ip" {
  description = "Public IP of public EC2"
  value       = aws_instance.public_ec2.public_ip
}

output "private_ec2_ip" {
  description = "Private IP of private EC2"
  value       = aws_instance.private_ec2.private_ip
}