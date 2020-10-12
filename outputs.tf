output "ext-alb" {
  value = module.ext-alb.my-elb-dns-name
}
output "int-aws" {
  value = module.int-alb.my-elb-dns-name
}