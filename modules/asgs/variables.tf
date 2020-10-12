variable "instance-type" {
  type = string
}
variable "security_groups" {
  type = list
}
variable "instance-ami" {
  type = string
}
variable "instance-key-name" {
  type = string
}
variable "alb-asg-name" {
  type = string
}
variable "min-size" {
  type = number
}
variable "max-size" {
  type = number
}
variable "desired-size" {
  type = number
}

variable "alb-id" {}
variable "alb-target-group-arn" {}