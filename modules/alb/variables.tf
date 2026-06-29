variable "vpc_id" {
    description = "VPC ID for the target group"
    type = string
}
variable "public_subnet_az1_id" {
    description = "Public subnet ID in AZ1 for the ALB"
    type = string
}
variable "public_subnet_az2_id" {
    description = "Public subnet ID in AZ2 for the ALB"
    type = string
}
variable "alb_sg_id" {
    description = "Security group ID for the ALB"
    type = string
}
variable "environment" {
    description = "Environment name for tagging"
    type = string
}