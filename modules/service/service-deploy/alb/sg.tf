resource "aws_security_group" "alb" {
  name        = "${var.app_full}-alb-sg"
  vpc_id      = var.vpc_id
  description = "For ${var.app_full} ALB"

  tags = merge(
    {
      "Name" = "${var.app_full}-alb-sg"
    },
    var.tags
  )

  ingress {
    description = "Allow any inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow any outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}