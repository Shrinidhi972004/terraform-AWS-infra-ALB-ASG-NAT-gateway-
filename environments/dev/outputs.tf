output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "bastion_az1_public_ip" {
  description = "SSH into this to reach AZ1 private instances"
  value       = module.bastion.bastion_az1_public_ip
}

output "bastion_az2_public_ip" {
  description = "SSH into this to reach AZ2 private instances"
  value       = module.bastion.bastion_az2_public_ip
}

output "alb_dns_name" {
  description = "Hit this in browser to reach your app via ALB"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.asg.asg_name
}