output "bastion_az1_public_ip" {
  description = "Public IP of bastion host in AZ1"
  value       = aws_instance.bastion_az1.public_ip
}

output "bastion_az2_public_ip" {
  description = "Public IP of bastion host in AZ2"
  value       = aws_instance.bastion_az2.public_ip
}