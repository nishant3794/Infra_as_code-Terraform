variable "ami" { }
variable "instance_type" { }
variable "key_name" { }
variable "security_groups" { }
variable "subnet_id" { }
variable "associate_public_ip_address" { }
variable "user_data" { }
variable "root_volume_type" { }
variable "root_volume_size" { }
variable "root_delete_on_termination" { }
variable "tag_name" { }

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key.key_name
  vpc_security_group_ids      = var.security_groups
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  user_data                   = var.user_data

  root_block_device {
    volume_type               = var.root_volume_type
    volume_size               = var.root_volume_size
    delete_on_termination     = var.root_delete_on_termination
  }

  tags = {
    Name                      = var.tag_name
  }

}

output "instance-id" { value = "${aws_instance.ec2.id}" }
output "asg-arn" { value = "${aws_instance.ec2.arn}" }
output "private-key" { value = "${tls_private_key.key.private_key_pem}" }