# ALB Configuration
resource "aws_lb" "openaiflask" {
  name               = "openaiflask-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "openaiflask-alb"
  }
}

resource "aws_lb_target_group" "openaiflask" {
  name     = "openaiflask-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "openaiflask-tg"
  }
}

resource "aws_lb_listener" "openaiflask" {
  load_balancer_arn = aws_lb.openaiflask.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.openaiflask.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.openaiflask.arn
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.openaiflask.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


// Security Group for ALB

resource "aws_security_group" "alb" {
  name        = "openaiflask-alb-sg-${random_string.rando.result}"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "openaiflask-alb-sg-${random_string.rando.result}"
  }
}