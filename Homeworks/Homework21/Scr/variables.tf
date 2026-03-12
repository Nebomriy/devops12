variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "SAM_4_DANIT"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "How many EC2 instances to create"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to private SSH key on Mac"
  type        = string
}