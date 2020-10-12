output "my-subnets" {
  value = [for i in data.aws_subnet.my-subnets : i.id]
}
output "vpc_id" {
  value = data.aws_vpc.my-default-vpc.id
}