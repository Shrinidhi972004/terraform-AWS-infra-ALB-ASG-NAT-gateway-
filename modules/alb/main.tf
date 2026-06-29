resource "aws_lb" "this" {
  name               = "${var.environment}-alb"
  internal           = false         
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]

  subnets = [
    var.public_subnet_az1_id,
    var.public_subnet_az2_id
  ]

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path = "/"
    port = "traffic-port"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
    matcher = "200"
  }

  tags = {
    Name        = "${var.environment}-tg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}