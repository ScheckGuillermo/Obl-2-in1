resource "aws_lb" "app_lb" {
  name               = var.elb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = var.elb_name
  }
}

resource "aws_lb_target_group" "app_lb_tg" {
  name     = "${var.elb_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.elb_name}-tg"
  }
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_lb_tg_attachment" {
  for_each         = toset(var.instance_ids)
  target_group_arn = aws_lb_target_group.app_lb_tg.arn
  target_id        = each.key
  port             = 80
}
