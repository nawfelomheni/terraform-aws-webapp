resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = var.alb-arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.alb-targetgroup-arn

  }


}
resource "aws_alb_listener_rule" "alb-listener-rule" {
  listener_arn = aws_lb_listener.alb-listener.arn
  action {
    type             = "forward"
    target_group_arn = var.alb-targetgroup-arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }

}