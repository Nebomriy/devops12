output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the main VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway"
  value       = aws_nat_gateway.nat.id
}

output "master_security_group_id" {
  description = "ID of the Jenkins master security group"
  value       = aws_security_group.master_sg.id
}

output "worker_security_group_id" {
  description = "ID of the Jenkins worker security group"
  value       = aws_security_group.worker_sg.id
}

output "jenkins_master_instance_id" {
  description = "Instance ID of Jenkins master"
  value       = aws_instance.jenkins_master.id
}

output "jenkins_master_public_ip" {
  description = "Public IP of Jenkins master"
  value       = aws_instance.jenkins_master.public_ip
}

output "jenkins_master_private_ip" {
  description = "Private IP of Jenkins master"
  value       = aws_instance.jenkins_master.private_ip
}

output "jenkins_worker_spot_request_id" {
  description = "Spot request ID of Jenkins worker"
  value       = aws_spot_instance_request.jenkins_worker.id
}

output "jenkins_worker_private_ip" {
  description = "Private IP of Jenkins worker"
  value       = aws_spot_instance_request.jenkins_worker.private_ip
}
