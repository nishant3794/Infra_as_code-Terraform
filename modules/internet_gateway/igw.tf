
variable "vpc_id" { }
variable "tag_name" { }

resource "aws_internet_gateway" "gw" {

  vpc_id        = var.vpc_id
  tags = {
    Name        = var.tag_name
  }
  lifecycle {
    create_before_destroy   = true
  }
}
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name = "${var.tag_name}-public-route"
  }
}

 resource "aws_route" "public" {
   route_table_id            = aws_route_table.public.id
   destination_cidr_block    = "0.0.0.0/0"
   gateway_id                = aws_internet_gateway.gw.id
 }

output "igw-id" { value = "${aws_internet_gateway.gw.id}" }
output "public_route_table_id" { value = "${aws_route_table.public.id}"}