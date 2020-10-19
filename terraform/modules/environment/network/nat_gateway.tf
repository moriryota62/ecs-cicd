resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    {
      "Name" = "${var.pj}-nat-gateway"
    },
    var.tags
  )
}