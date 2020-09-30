resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      "Name" = "${var.pj}-private-route-table"
    },
    var.tags
  )
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

resource "aws_route_table_association" "private" {
  for_each = toset(var.subnet_private_cidrs)

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private.id
}
