resource "aws_security_group" "gitlab" {
  name        = "${var.pj}-gitlab-sg"
  vpc_id      = var.vpc_id
  description = "For GitLab EC2"

  tags = merge(
    {
      "Name" = "${var.pj}-gitlab-sg"
    },
    var.tags
  )

  # インバウンドは設定しない
  # ingress {

  # }

  egress {
    description = "Allow any outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}