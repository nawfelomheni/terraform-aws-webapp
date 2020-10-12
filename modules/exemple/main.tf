////egress Traffic !!

resource "aws_security_group_rule" "my-alb-sec-group-rules-ingress-cidr" {
  count = 1 - var.ingress-is-cidr
  from_port         = var.ingress-from-port
  protocol          = "TCP"
  security_group_id = local.albsecgroup
  to_port           = var.ingress-to-port
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "my-alb-sec-group-rules-ingress-secgroup" {
  count = var.ingress-is-cidr
  from_port         = var.ingress-from-port
  protocol          = "TCP"
  security_group_id = local.albsecgroup
  to_port           = var.ingress-to-port
  type              = "ingress"
  source_security_group_id = var.ingress-source-secgroup
}

///////
//TODO
data "aws_security_group" "instnace-sec-group" {
  name = "terraform-secgroup-alb-inst"

}
resource "aws_security_group_rule" "my-alb-sec-group-rules-egress" {
  from_port                = var.egress-from-port
  protocol                 = "TCP"
  source_security_group_id = var.egress-dst-secgroup
  security_group_id        = local.albsecgroup
  to_port                  = var.egress-to-port
  type                     = "egress"
}
locals {

  albsecgroup = aws_security_group.alb-sec-group.id
}
resource "aws_security_group" "alb-sec-group" {
  name        = "alb-sec-group"
  description = "the default ALB se c group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "alb-sec-group"
  }
}