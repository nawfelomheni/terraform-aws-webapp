provider "aws" {
  version = "~> 3.2.0"
  region  = "eu-west-3"
}
////////////////////////////////// Network //////////////////////////
module "alb-network" {
  source = "./modules/network"
}
//////////////////////// Sec Group ////////////////////////
module "ext-securitygroups" {
  source                  = "./.terraform/modules/exemple"
  vpc_id                  = module.alb-network.vpc_id
  egress-dst-secgroup     = "sec2"
  egress-from-port        = 80
  egress-to-port          = 80
  ingress-from-port       = 80
  ingress-is-cidr         = 0
  ingress-source-secgroup = ""
  ingress-to-port         = 80
}

///// Listener ::
module "ext-alb-listener" {
  source              = "./modules/listeners"
  alb-arn             = module.ext-alb.alb-arn
  alb-targetgroup-arn = module.ext-alb-targetgroup.alb-targetgroup-arn
}

variable "terraform-ext-alb" {
  default = "terraform-ext-alb"
}
////

module "ext-alb" {
  source               = "./modules/alb"
  alb-name             = var.terraform-ext-alb
  alb-secgroup         = module.ext-securitygroups.albsecgroup
  alb-subnets          = module.alb-network.my-subnets
  alb-target-group-arn = module.ext-alb-targetgroup.alb-targetgroup-arn
}
module "ext-alb-targetgroup" {
  source = "./modules/targetgroups"
  //instance-private-id = 'to_add'
  vpc_id = module.alb-network.vpc_id

}
data "aws_instance" "existing-instance" {
  instance_id = "i-093287c7daafae63e"
}
module "ext-asg" {
  source               = "./modules/asgs"
  alb-asg-name         = "terraform-ext-asg"
  alb-id               = module.ext-alb.alb-id
  desired-size         = 1
  instance-ami         = data.aws_instance.existing-instance.ami
  instance-key-name    = data.aws_instance.existing-instance.key_name
  instance-type        = data.aws_instance.existing-instance.instance_type
  max-size             = 1
  min-size             = 1
  security_groups      = [module.ext-securitygroups.albsecgroup]
  alb-target-group-arn = module.ext-alb-targetgroup.alb-targetgroup-arn
}

resource "aws_security_group" "webapp" {
  name = "terraform-webapp-segroup"
  egress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [module.int-securitygroups.albsecgroup]
  }
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 0
    security_groups = [module.ext-securitygroups.albsecgroup]
  }
  vpc_id = module.alb-network.vpc_id
}



////////// Internal ALB
module "int-securitygroups" {
  source                  = "./modules/exemple"
  vpc_id                  = module.alb-network.vpc_id
  egress-dst-secgroup     = "sec2"
  egress-from-port        = 80
  egress-to-port          = 80
  ingress-from-port       = 80
  ingress-is-cidr         = 1
  ingress-source-secgroup = "sec1"
  ingress-to-port         = 80
}

///// Listener ::
module "int-alb-listener" {
  source              = "./modules/listeners"
  alb-arn             = module.int-alb.alb-arn
  alb-targetgroup-arn = module.int-alb-targetgroup.alb-targetgroup-arn
}


////
module "int-alb" {
  source               = "./modules/alb"
  alb-name             = "terraform-ext-alb"
  alb-secgroup         = module.int-securitygroups.albsecgroup
  alb-subnets          = module.alb-network.my-subnets
  alb-target-group-arn = module.int-alb-targetgroup.alb-targetgroup-arn
}
module "int-alb-targetgroup" {
  source = "./modules/targetgroups"
  //instance-private-id = 'to_add'
  vpc_id = module.alb-network.vpc_id

}
module "int-asg" {
  source               = "./modules/asgs"
  alb-asg-name         = "terraform-int-asg"
  alb-id               = module.int-alb.alb-id
  desired-size         = 1
  instance-ami         = data.aws_instance.existing-instance.ami
  instance-key-name    = data.aws_instance.existing-instance.key_name
  instance-type        = data.aws_instance.existing-instance.instance_type
  max-size             = 1
  min-size             = 1
  security_groups      = [module.int-securitygroups.albsecgroup]
  alb-target-group-arn = module.int-alb-targetgroup.alb-targetgroup-arn
}

resource "aws_security_group" "appservers" {
  name = "terraform-appservers-segroup"
  egress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    //security_groups = [var.rds-secgroup]
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [module.int-securitygroups.albsecgroup]
  }
  vpc_id = module.alb-network.vpc_id
}
variable "rds-secgroup" {
  default = "hello"
}

