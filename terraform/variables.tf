# variables.tf
# Defines all configurable parameters for the infrastructure.

variable "aws_region" {
  description = "AWS region where resources will be created (e.g., us-east-1, us-west-2)"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for the Kubernetes master node"
  default     = "t2.medium"
}

variable "ssh_public_key_path" {
  description = "Local path to your SSH public key file"
  default     = "~/.ssh/id_rsa.pub"
}

variable "manual_ami_id" {
  description = "AMI ID for the EC2 instance (must match the chosen region)"
  default     = "ami-0236922087fa98b6e"   # Amazon Linux 2 in us-east-1
}

variable "instance_type_worker" {
  description = "EC2 instance type for the worker node"
  default     = "t2.small"   # cheaper than t2.medium
}
