provider "aws" {
  region        = "ap-south-1"
}

terraform {
 /*backend "s3" {
   bucket       = "tf-state"
   key         = "resources/terraform.tfstate"
   region       = "ap-south-1"
  }*/
  backend "local" {
    path = "./terraform.tfstate"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name      = "name"
    values    = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
     name   = "virtualization-type"
     values = ["hvm"]
 }
}
