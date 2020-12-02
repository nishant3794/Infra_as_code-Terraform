variable "availability_zone" { }
variable "cidr_block" { }
variable "vpc_id" { }
variable "tag_name" { }
variable "tag_privacy" { }
variable "private_route_table_ids" { }
resource "aws_subnet" "private" {

  availability_zone       = var.availability_zone
  cidr_block              = var.cidr_block
  vpc_id                  = var.vpc_id
  tags = {
    Name                  = var.tag_name
    Privacy               = var.tag_privacy
  }
  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_route_table_association" "private" {

  subnet_id               = aws_subnet.private.id
  route_table_id          = var.private_route_table_ids
  lifecycle {
    create_before_destroy = true
  }
}

output "subnet-id" { value = "${aws_subnet.private.id}" }
output "subnet-arn" { value = "${aws_subnet.private.arn}" }