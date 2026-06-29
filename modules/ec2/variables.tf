variable "ami_id" {
    description = "the ami id for the ec2 instance"
    type = string
}
variable "instance_type" {
    description = "the instance type for the ec2 instance"
    type = string
}
variable "instance_name" {
    description = "the name for the ec2 instance"
    type = string
}
variable "key_name" {
    description = "the key name for the ec2 insstance"
    type = string
}
variable "subnet_id" {
    description = "the subnet id for the ec2 instance"
    type = string
}
variable "sg_id" {
    description = "the security group id for the ec2 instance"
    type = string
}
variable "environment" {
    description = "the environment for the ec2 instance"
    type = string
}