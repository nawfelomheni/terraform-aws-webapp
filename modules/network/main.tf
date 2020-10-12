data "aws_vpc" "my-default-vpc" {
  default = true
}
locals {
  vpc_id     = data.aws_vpc.my-default-vpc.id
  subnet_ids = data.aws_subnet_ids.my-subnet-ids.ids

}
data "aws_subnet_ids" "my-subnet-ids" {
  vpc_id = local.vpc_id
}
data "aws_subnet" "my-subnets" {
  for_each = local.subnet_ids
  id       = each.value
}
