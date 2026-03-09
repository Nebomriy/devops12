output "instance_public_ip" {
  description = "Public IP of the created EC2 instance"
  value       = module.nginx_ec2.instance_public_ip
}

output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = module.nginx_ec2.instance_id
}