// albを作成。
resource "aws_alb" "alb" {
  name                       = "${var.name}-alb"
  security_groups            = ["${aws_security_group.alb.id}"]
  subnets = [
    "${aws_subnet.public-a.id}",
    "${aws_subnet.public-c.id}",
  ]
  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket = "${var.name}-alb-logs-01"
  }
}

// albのターゲットグループ
resource "aws_alb_target_group" "alb" {
  name     = "${var.name}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    interval            = 60
    path                = "/"
    // NOTE: defaultはtraffic-port
    //port                = 80
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = 302
  }
}

// 443ポートの設定。今回は事前にAWS Certificate Managerで作成済みの証明書を設定。
resource "aws_alb_listener" "alb_443" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${aws_acm_certificate.cert.arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}

output "alb" {
  value = {
    dns_name         = "${aws_alb.alb.dns_name}"
    arn              = "${aws_alb.alb.arn}"
    target_group_arn = "${aws_alb_target_group.alb.arn}"
  }
}
