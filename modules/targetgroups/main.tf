resource "aws_alb_target_group" "alb-targetgroup" {
  name        = "terraform-alb-targetgroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  deregistration_delay = 30
  health_check {
    healthy_threshold = 2
    interval = 15
    unhealthy_threshold = 2
  }
}
/*
resource "aws_alb_target_group_attachment" "alb-targetgroup-attachement" {
  target_group_arn = aws_alb_target_group.alb-targetgroup.arn
  target_id        = var.instance-private-id

}
*/
