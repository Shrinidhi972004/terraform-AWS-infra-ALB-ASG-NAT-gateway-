variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type = string
}
variable "instance_type" {
    description = "Instance type for the EC2 instance"
    type = string
} 
variable "key_name" {
    description = "Key pair name for SSH access"
    type = string
}
variable "ec2_sg_id" {
    description = "Security group ID for the EC2 instance"
    type = string
}
variable "private_subnet_az1_id" {
  description = "Private subnet ID in AZ1"
  type        = string
}
variable "private_subnet_az2_id" {
  description = "Private subnet ID in AZ2"
  type        = string
}
variable "target_group_arn" {
    description = "ARN of the target group for the EC2 instance"
    type = string
}
variable "environment" {
    description = "Environment name for tagging"
    type = string
}