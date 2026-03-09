variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet where EC2 instance will run"
  type        = string
}

variable "list_of_open_ports" {
  description = "Ports that will be opened in security group"
  type        = list(number)
  default     = [80, 22]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}