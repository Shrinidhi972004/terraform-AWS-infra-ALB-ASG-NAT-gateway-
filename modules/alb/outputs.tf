output "alb_dns_name" {
  description = "DNS name of the ALB - use this to access your app"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group - ASG needs this to register instances"
  value       = aws_lb_target_group.this.arn
}