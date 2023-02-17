resource "aws_security_group" "this" {
  name        = "${var.name}-alb-sg"
  description = "Security Group for ALB ${var.name}"
  vpc_id      = data.aws_vpc.this.id
}

resource "aws_security_group_rule" "access_from_my_ip" {
  security_group_id = aws_security_group.this.id
  description       = "Allow connecting from my ip"

  type        = "ingress"
  from_port   = "${var.from_listen_alb_port}"
  to_port     = "${var.to_listen_alb_port}"
  protocol    = "tcp"
  cidr_blocks = ["${var.my_ip}"]
  
}

resource "aws_security_group_rule" "egress_anywhere" {
  security_group_id = aws_security_group.this.id
  description       = "Allow outbound traffic"

  type      = "egress"
  from_port = "${var.from_port_tg}"
  to_port   = "${var.to_port_tg}"
  protocol  = "all"
  
  source_security_group_id = var.instance_sg_id
}