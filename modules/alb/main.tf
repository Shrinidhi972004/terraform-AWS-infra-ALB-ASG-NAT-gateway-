resource "aws_lb" "this" {
  # checkov:skip=CKV_AWS_91:ALB access logs require additional S3 bucket setup - out of scope for training
  # checkov:skip=CKV2_AWS_28:WAF out of scope for training environment
  # checkov:skip=CKV2_AWS_20:HTTP to HTTPS redirect requires SSL certificate not available in training
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]

  subnets = [
    var.public_subnet_az1_id,
    var.public_subnet_az2_id
  ]
  #checkov:skip=CKV_AWS_150:Deletion protection disabled intentionally for planned infrastructure teardown
  enable_deletion_protection = false
  drop_invalid_header_fields = true

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_target_group" "this" {
  # checkov:skip=CKV_AWS_378:HTTP protocol intentional - no SSL cert available in training
  name     = "${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200"
  }

  tags = {
    Name        = "${var.environment}-tg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_listener" "http" {
  # checkov:skip=CKV_AWS_2:No SSL certificate available in training environment
  # checkov:skip=CKV_AWS_103:TLS policy not applicable without HTTPS listener
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}