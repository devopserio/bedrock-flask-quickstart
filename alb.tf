# ALB Configuration
resource "aws_lb" "bedrockflask" {
  depends_on = [ aws_acm_certificate.bedrockflask, aws_security_group.alb ]
  name               = "bedrockflask-alb-${random_string.rando.result}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = false

  tags = {
    Name = "bedrockflask-alb"
  }
}


resource "aws_lb_target_group" "bedrockflask" {
  name     = "bedrockflask-tg-${random_string.rando.result}"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.selected.id

  health_check {
    enabled             = true
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 86400  # 1 day in seconds
    enabled         = true
  }

  tags = {
    Name = "bedrockflask-tg"
  }
}


resource "aws_lb_target_group_attachment" "bedrockflask" {
  for_each = {
    for idx, instance in aws_instance.bedrockflask : 
    idx => instance
  }
  target_group_arn = aws_lb_target_group.bedrockflask.arn
  target_id        = each.value.id
  port             = 8000
}


resource "aws_lb_listener" "bedrockflask" {
  load_balancer_arn = aws_lb.bedrockflask.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.bedrockflask.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bedrockflask.arn
  }
}

resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_lb.bedrockflask.arn
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
  name        = "bedrockflask-alb-sg-${random_string.rando.result}"
  description = "Security group for ALB"
  vpc_id      = data.aws_vpc.selected.id

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
    Name = "bedrockflask-alb-sg-${random_string.rando.result}"
  }
}