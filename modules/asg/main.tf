resource "aws_launch_template" "this" {
  name_prefix = "${var.environment}-lt-"
  image_id = var.ami_id
  instance_type = var.instance_type
  key_name = var.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups = [var.ec2_sg_id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
apt update -y
apt install -y nginx

TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/local-ipv4)

echo "<h1>Web Server</h1><p>Instance IP: $PRIVATE_IP</p>" > /var/www/html/index.html

systemctl enable --now nginx
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.environment}-asg-instance"
      Environment = var.environment
      ManagedBy = "Terraform"
    }
  }

  tags = {
    Name  = "${var.environment}-lt"
    Environment = var.environment
    ManagedBy = "Terraform"
  }
}

resource "aws_autoscaling_group" "this" {
  name = "${var.environment}-asg"
  desired_capacity = 2
  max_size = 4
  min_size = 1

  vpc_zone_identifier = [
    var.private_subnet_az1_id,
    var.private_subnet_az2_id
  ]

  target_group_arns = [var.target_group_arn]
  health_check_type = "ELB"
  health_check_grace_period = 180

  launch_template {
    id = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "${var.environment}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key = "Environment"
    value = var.environment
    propagate_at_launch = true
  }

  tag {
    key = "ManagedBy"
    value = "Terraform"
    propagate_at_launch = true
  }
}