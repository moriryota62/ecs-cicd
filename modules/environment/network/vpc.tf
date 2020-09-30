resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr

  tags = merge(
    {
      "Name" = "${var.pj}-vpc"
    },
    var.tags
  )
}