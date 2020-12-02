variable "vpc_id" { }
variable "subnet_id" { }
variable "tag_name" { }

resource "aws_eip" "nat" {
  vpc   = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "gw" {

  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id
  tags = {
    Name        = var.tag_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags  =  {
    Name        = "${var.tag_name}-route-table"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "private" {
  route_table_id          = aws_route_table.private.id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.gw.id
}

output "ngw-id" { value = "${aws_nat_gateway.gw.id}" }
output "ngw-private-ip" { value = "${aws_nat_gateway.gw.private_ip}" }
output "ngw-public-ip" { value = "${aws_nat_gateway.gw.public_ip}" }
output "private_route_table_id" { value = "${aws_route_table.private.id}"}