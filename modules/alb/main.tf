provider "aws" {
    region = "us-east-1"
}

resource "aws_alb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = data.aws_subnets.this.ids
}

resource "aws_lb_target_group" "this" {
  vpc_id   = data.aws_vpc.this.id
  name     = "${var.name}-target-group"
  port     = "${var.port_tg}"
  protocol = "HTTP"

  health_check {
    interval = 10
    matcher  = "200"
    path     = "/"
    timeout  = 5
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_ids[count.index]
  port             = "${var.port_tg}"
}

resource "aws_alb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  protocol          = "HTTP"
  port              = "${var.listen_alb_port}"

  default_action {
    # type = "fixed-response"

    # fixed_response {
    #     content_type = "text/plain"
    #     message_body = "{\"message\": \"Hello from Terraform\"}"
    #     status_code  = "200"
    # }

    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener_rule" "ping-pong" {
  listener_arn = aws_alb_listener.this.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "ping"
      status_code  = "200"
    }
  }

  condition {
    query_string {
      key   = "ping"
      value = "pong"
    }

    query_string {
      value = "bar"
    }
  }
}
