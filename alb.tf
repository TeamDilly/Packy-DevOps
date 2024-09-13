resource "aws_lb" "packy-v2-alb" {
  name = "packy-v2-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.packy-v2-alb-sg.id ]
  subnets = [ aws_subnet.packy-v2-public-subnet-01.id, aws_subnet.packy-v2-public-subnet-02.id ]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "packy-v2-web-dev-tg" {
    name = "packy-v2-web-dev-tg"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.packy-v2-vpc.id

    health_check {
      path = "/"
      interval = 30
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group" "packy-v2-web-prod-tg" {
    name = "packy-v2-web-prod-tg"
    port = 3001
    protocol = "HTTP"
    vpc_id = aws_vpc.packy-v2-vpc.id

    health_check {
      path = "/"
      interval = 30
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "packy-v2-web-dev-tg-attachment" {
  target_group_arn = aws_lb_target_group.packy-v2-web-dev-tg.arn
  target_id = aws_instance.packy-v2-web-ec2.id
  port = 3000
}

resource "aws_lb_target_group_attachment" "packy-v2-web-prod-tg-attachment" {
  target_group_arn = aws_lb_target_group.packy-v2-web-prod-tg.arn
  target_id = aws_instance.packy-v2-web-ec2.id
  port = 3001 
}

resource "aws_lb_listener" "packy-v2-alb-http-listener" {
  load_balancer_arn = aws_lb.packy-v2-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      host = "#{host}"
      path = "/#{path}"
      port = "443"
      protocol = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "packy-v2-alb-https-listener" {
  load_balancer_arn = aws_lb.packy-v2-alb.arn
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate.packy-v2-web-acm-wildcard.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "packy-v2-lb-web-listener-rule-dev" {
    listener_arn = aws_lb_listener.packy-v2-alb-https-listener.arn
    priority = 1

    condition {
        host_header {
          values = [ "dev.packyforyou.com" ]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.packy-v2-web-dev-tg.arn
    }
}

resource "aws_lb_listener_rule" "packy-v2-lb-web-listener-rule-prod" {
    listener_arn = aws_lb_listener.packy-v2-alb-https-listener.arn
    priority = 2

    condition {
        host_header {
            values = [ "packyforyou.com" ]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.packy-v2-web-prod-tg.arn
    }
}