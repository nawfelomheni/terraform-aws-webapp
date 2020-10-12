resource "aws_launch_template" "asg-launch-template" {
  name = "asg-launch-template"
  ebs_optimized                        = true
  image_id                             = var.instance-ami
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance-type
  key_name                             = var.instance-key-name
  network_interfaces {
    associate_public_ip_address = true
    //subnet_id                   = var.subnet_id
    security_groups             = var.security_groups
    delete_on_termination       = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name          = "mysvc"
    }
  }
  user_data = <<-EOT
#!/bin/bash

########################################################
##### US #####
###############################User data 2#########################

# get admin privileges
sudo su

# install httpd (Linux 2 version)
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html

EOT
  lifecycle {
    ignore_changes = [
      image_id,
    ]
  }
}

resource "aws_autoscaling_group" "alb-asg" {
name = var.alb-asg-name
   health_check_type         = "ELB"
  health_check_grace_period = 120
  termination_policies      = ["OldestInstance"]
  launch_template {
    id      = aws_launch_template.asg-launch-template.id
    version = aws_launch_template.asg-launch-template.latest_version
  }
  min_size = var.min-size
  max_size = var.max-size
  desired_capacity = var.desired-size

  lifecycle {
    create_before_destroy = true
  }
//  target_group_arns = [var.targetgroup-arn]
}

resource "aws_autoscaling_attachment" "ext-alb-targetgroup-attachement" {
  autoscaling_group_name = aws_autoscaling_group.alb-asg.name
  alb_target_group_arn = var.alb-target-group-arn
}