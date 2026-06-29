variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_az1" {
  description = "CIDR for public subnet in AZ1"
  type        = string
}

variable "public_subnet_cidr_az2" {
  description = "CIDR for public subnet in AZ2"
  type        = string
}

variable "private_subnet_cidr_az1" {
  description = "CIDR for private subnet in AZ1"
  type        = string
}

variable "private_subnet_cidr_az2" {
  description = "CIDR for private subnet in AZ2"
  type        = string
}

variable "az1" {
  description = "First availability zone"
  type        = string
}

variable "az2" {
  description = "Second availability zone"
  type        = string
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
}