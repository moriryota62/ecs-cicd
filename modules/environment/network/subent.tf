resource "aws_subnet" "public" {
  for_each = toset(var.subnet_public_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = each.key

  tags = merge(
    {
      "Name" = "${var.pj}-public-subnet"
    },
    var.tags
  )
}

resource "aws_subnet" "private" {
  for_each = toset(var.subnet_private_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = each.key

  tags = merge(
    {
      "Name" = "${var.pj}-private-subnet"
    },
    var.tags
  )
}
