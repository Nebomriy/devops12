variable "aws_region" {
  description = "AWS region for Step Project 3"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "stepproject-3"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
  default     = "eu-central-1a"
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

variable "master_instance_type" {
  description = "Instance type for Jenkins master"
  type        = string
  default     = "t2.micro"
}

variable "worker_instance_type" {
  description = "Instance type for Jenkins worker"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Pinned AMI ID for Jenkins master and worker"
  type        = string
  default     = "ami-0cf4768e2f1e520c5"
}
