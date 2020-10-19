output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subent_ids" {
  value = [
    for subnet in aws_subnet.public:
    subnet.id
  ]
}

output "private_subent_ids" {
  value = [
    for subnet in aws_subnet.private:
    subnet.id
  ]
}
