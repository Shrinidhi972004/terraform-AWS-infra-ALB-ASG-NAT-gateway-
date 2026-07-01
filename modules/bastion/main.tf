resource "aws_instance" "bastion_az1" {
  # checkov:skip=CKV_AWS_135:t2.micro does not support EBS optimization
  # checkov:skip=CKV2_AWS_41:IAM role for bastion out of scope for this activity
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_az1_id
  vpc_security_group_ids = [var.bastion_sg_id]
  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name        = "${var.environment}-bastion-az1"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}


resource "aws_instance" "bastion_az2" {
  # checkov:skip=CKV_AWS_135:t2.micro does not support EBS optimization
  # checkov:skip=CKV2_AWS_41:IAM role for bastion out of scope for this activity
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.public_subnet_az2_id
  vpc_security_group_ids = [var.bastion_sg_id]
  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
    http_put_response_hop_limit = 1
  }
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.environment}-bastion-az2"
    Environment = var.environment
    ManagedBy = "terraform"
  }
}