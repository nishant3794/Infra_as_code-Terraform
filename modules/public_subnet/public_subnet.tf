variable "availability_zone" { }
variable "cidr_block" { }
variable "vpc_id" { }
variable "tag_name" { }
variable "tag_privacy" { }
variable "public_route_table_ids" { }
resource "aws_subnet" "public" {

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

resource "aws_route_table_association" "public" {

  subnet_id               = aws_subnet.public.id
  route_table_id          = var.public_route_table_ids
  lifecycle {
    create_before_destroy = true
  }
}

output "subnet-id" { value = "${aws_subnet.public.id}" }
output "subnet-arn" { value = "${aws_subnet.public.arn}" }