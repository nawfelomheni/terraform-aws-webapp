variable "vpc_id" {}
variable "ingress-from-port" {
  type = number
}
variable "ingress-to-port" {
  type = number
}
variable "ingress-is-cidr" {
  type = number
}

variable "ingress-source-secgroup" {}


/////// Egress
variable "egress-from-port" {
  type = number
}
variable "egress-to-port" {type = number}
variable "egress-dst-secgroup" {}