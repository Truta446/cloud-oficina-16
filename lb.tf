resource "aws_lb" "proj_elb" {
  name               = "projeto-lb-php"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.network.public_subnets[*].id
  security_groups    = [module.security.sg-elb.id]
}

resource "aws_lb_target_group" "proj_tg" {
  name        = "projeto-tg"
  port        = "8080"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.network.vpc_id
  health_check {
    port                = 8080
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 20
    path                = "/"
    interval            = 30
  }
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }
}

/* resource "aws_lb_listener" "proj_https" {
  load_balancer_arn = aws_lb.proj_elb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.elb_cert.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.proj_tg.arn
  }
} */

resource "aws_lb_listener" "proj_http" {
  load_balancer_arn = aws_lb.proj_elb.arn
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