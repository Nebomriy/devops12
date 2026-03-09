variable "vpc_id" {
  description = "VPC ID where security group will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 instance will run"
  type        = string
}

variable "list_of_open_ports" {
  description = "List of open inbound ports"
  type        = list(number)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}