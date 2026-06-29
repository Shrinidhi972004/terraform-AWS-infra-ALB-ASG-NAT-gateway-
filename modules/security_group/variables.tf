variable "vpc_id" {
  description = "VPC ID to create security groups in"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into instances"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}