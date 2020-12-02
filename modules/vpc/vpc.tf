variable "cidr_block" { }
variable "instance_tenancy" { default = "default" }
variable "enable_dns_support" { default = "true" }
variable "enable_dns_hostnames" { default = "true" }
variable "assign_generated_ipv6_cidr_block" { default = "false" }
variable "tag_name" { }


resource "aws_vpc" "vpc" {
  cidr_block                         = var.cidr_block
  instance_tenancy                   = var.instance_tenancy
  enable_dns_support                 = var.enable_dns_support
  enable_dns_hostnames               = var.enable_dns_hostnames
  assign_generated_ipv6_cidr_block   = var.assign_generated_ipv6_cidr_block
  tags = {
    Name                             = var.tag_name
      }
  lifecycle {
    create_before_destroy            = "true"
  }
}
resource "aws_default_security_group" "dsg" {
  vpc_id                              = aws_vpc.vpc.id
  ingress {
    from_port                         = 0
    to_port                           = 0
    protocol                          = "-1"
    self                              = true
  }
  egress {
    from_port                         = 0
    to_port                           = 0
    protocol                          = "-1"
    cidr_blocks                       = ["0.0.0.0/0"]
  }
  tags = {
    Name                              = "${var.tag_name}-default-sg"
  }


}
output "vpc-arn" { value = "${aws_vpc.vpc.arn}" }
output "vpc-id" { value = "${aws_vpc.vpc.id}" }
output "vpc-cidr-block" { value = "${aws_vpc.vpc.cidr_block}" }
output "vpc-drt-id" { value = "${aws_vpc.vpc.default_route_table_id}"}
output "vpc-dsg-id" { value = "${aws_vpc.vpc.default_security_group_id}"}