output "alb_sg_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb.id
}

output "bastion_sg_id" {
  description = "Security group ID for bastion hosts"
  value       = aws_security_group.bastion.id
}

output "ec2_sg_id" {
  description = "Security group ID for private ASG instances"
  value       = aws_security_group.ec2.id
}