resource "aws_instance" "bastion_az1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_az1_id
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name        = "${var.environment}-bastion-az1"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_instance" "bastion_az2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_az2_id
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name        = "${var.environment}-bastion-az2"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}