variable "ami_id" {
  description = "AMI ID for bastion hosts"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion hosts"
  type = string
}

variable "key_name" {
  description = "AWS key pair name for SSH access"
  type = string
}

variable "public_subnet_az1_id" {
  description = "Public subnet ID in AZ1 for bastion 1"
  type = string
}

variable "public_subnet_az2_id" {
  description = "Public subnet ID in AZ2 for bastion 2"
  type = string
}

variable "bastion_sg_id" {
  description = "Security group ID for bastion hosts"
  type = string
}

variable "environment" {
  description = "Environment name for tagging"
  type = string
}