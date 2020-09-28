resource "aws_security_group" "service" {
  name        = "${var.service_name}-sg"
  vpc_id      = var.vpc_id
  description = "For ECS service ${var.service_name}"

  tags = merge(
    {
      "Name" = "${var.service_name}-sg"
    },
    var.tags
  )

  ingress {
    description     = "Allow any inbound"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = var.service_allow_inbound_sgs
    # cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow any inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}