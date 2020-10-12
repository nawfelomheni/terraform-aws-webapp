output "my-elb-dns-name" {
  value = aws_alb.alb.dns_name

}
output "alb-arn" {
 value = aws_alb.alb.arn
}
output "alb-id" {
  value = aws_alb.alb.id
}
