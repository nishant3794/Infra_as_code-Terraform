module "vpc" {
  source                    = "../modules/vpc"
  cidr_block                = "10.0.0.0/16"
  instance_tenancy          = "default"
  tag_name                  = "test-vpc"
}

module "igw" {
  source                    = "../modules/internet_gateway"
  tag_name                  = "test-igw"
  vpc_id                    = module.vpc.vpc-id
}

module "public_subnet" {
  source                    = "../modules/public_subnet"
  vpc_id                    = module.vpc.vpc-id
  cidr_block                = "10.0.1.0/24"
  availability_zone         = "ap-south-1"
  tag_name                  = "test-public-subnet"
  tag_privacy               = "public"
  public_route_table_ids   = module.igw.public_route_table_id
}

module "ngw" {
  source                    = "../modules/nat-gateway"
  vpc_id                    = module.vpc.vpc-id
  subnet_id                 = module.public_subnet.subnet-id
  tag_name                  = "test-ngw"
}

module "private_subnet" {
  source                    = "../modules/private_subnet"
  vpc_id                    = module.vpc.vpc-id
  cidr_block                = "10.0.2.0/24"
  availability_zone         = "ap-south-1"
  tag_name                  = "test-private-subnet"
  tag_privacy               = "private"
  private_route_table_ids   = module.ngw.private_route_table_id
}

module "security_group" {
  source                    = "../modules/security_groups"
  vpc_id                    = module.vpc.vpc-id
  tag_name                  = "test-sg"
  description               = "Test security group"
  ingress_from_ports        = ["3306", "8080", "8"]
  ingress_to_ports          = ["3306", "8080", "0"]
  ingress_protocols         = ["tcp", "tcp", "icmp"]
  ingress_cidr_blocks       = ["10.0.0.0/16", "10.0.0.0/16", "10.0.0.0/16"]
  ingress_cidr_descriptions = ["sql", "java", "icmp"]
  ingress_sgid_from_ports   = []
  ingress_sgid_to_ports     = []
  ingress_sgid_protocols    = []
  ingress_sgid_descriptions = []
  source_security_group_id  = []
}

module "user_data" {
    source                  = "../modules/user_data"
}

module "ec2-instance" {
    source                  = "../modules/ec2"
    ami                     = data.aws_ami.ubuntu.id
    instance_type           = "t3a.micro"
    key_name                = "ec2_key_test"
    security_groups         = [module.security_group.security-group-id]
    subnet_id               = module.private_subnet.subnet-id
    associate_public_ip_address = false
    user_data               = module.user_data.user-data
    iam_instance_profile    =  ""
    root_volume_type        = "gp2"
    root_volume_size        =  "8"
    root_delete_on_termination = true
    tag_name                = "test_instance"
}