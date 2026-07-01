resource "aws_security_group" "alb" {
  # checkov:skip=CKV_AWS_260:ALB must accept HTTP from internet - intentional design
  # checkov:skip=CKV2_AWS_5:False positive - SG is attached to ALB in alb module
  name        = "${var.environment}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress removed - moved to aws_security_group_rule below to break circular dependency

  tags = {
    Name        = "${var.environment}-alb-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Separate rule resource - created after both SGs exist, breaking the cycle
# ALB sg referencing ec2 sg in egress AND ec2 sg referencing ALB sg in ingress = circular dependency
# Solution: keep the reference in ec2 sg ingress, move ALB egress to this standalone rule
resource "aws_security_group_rule" "alb_egress_to_ec2" {
  type                     = "egress"
  description              = "HTTP to EC2 instances only"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.ec2.id
}

resource "aws_security_group" "bastion" {
  # checkov:skip=CKV2_AWS_5:False positive - SG is attached to bastion instances in bastion module
  name        = "${var.environment}-bastion-sg"
  description = "Security group for bastion hosts"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from your IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "ICMP from your IP only"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "SSH to private instances"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "HTTPS for package updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-bastion-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_security_group" "ec2" {
  # checkov:skip=CKV2_AWS_5:False positive - SG is attached to ASG instances in asg module
  name        = "${var.environment}-ec2-sg"
  description = "Security group for private ASG instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "SSH from bastion only"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "ICMP from bastion only"
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "HTTPS outbound via NAT"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "HTTP outbound via NAT"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}