resource "aws_s3_bucket_object" "my-statefile-object" {
  bucket = "lilouchstestbucket006"
  key    = "myterraformstatefile"
}

provider "aws" {
  version = "~> 3.2.0"
  region  = "eu-west-3"
}


////////////////////// ALB ////////////////////////////////////////////
resource "aws_alb" "alb" {
  name            = var.alb-name
  subnets         = var.alb-subnets
  security_groups = [var.alb-secgroup]
  //  internal        = var.internal_alb
  //idle_timeout    = var.idle_timeout
  tags = {
    Name = "terraform-alb"
  }
  /*access_logs {
    bucket = var.s3_bucket
    prefix = "ELB-logs"
  }*/
}

///////////////////////////// Listener /////////////////////////////

///////////////////////////////////////////////////// Target Group ////////////////////////////


////////////////////////// Instance ///////////////////////
