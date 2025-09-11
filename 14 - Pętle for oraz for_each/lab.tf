provider "aws" {
  region  = "eu-central-1"
  access_key = var.lab_aws_key
  secret_key = var.lab_aws_secret
}

locals {
  vpc_cidr_block = "10.0.0.0/16"
}

resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = var.pod }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { pod = var.pod }
}

variable "subnets_in_az" {
  default = {
    "eu-central-1a" = 0,
    "eu-central-1b" = 1,
    "eu-central-1c" = 2
  }
}

resource "aws_subnet" "subnet_private" {
  for_each = var.subnets_in_az

  availability_zone = each.key
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 9, each.value)
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}

resource "aws_key_pair" "ec2key" {
  key_name = "publicKey"
  public_key = file("~/.ssh/TerraformLab.pub")
  tags = { pod = var.pod }
}

resource "aws_security_group" "sg_any" {
  name = "sg_any"
  vpc_id = aws_vpc.vpc.id
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { pod = var.pod }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
  }
  tags = { pod = var.pod }
}

resource "aws_route_table_association" "rta_subnet_public" {
  for_each = var.subnets_in_az

  subnet_id      = aws_subnet.subnet_private[each.key].id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_instance" "ec2_server" {
  for_each = var.subnets_in_az

  ami           = "ami-0c960b947cbb2dd16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private[each.key].id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name = aws_key_pair.ec2key.key_name
  tags = { pod = var.pod }
}

output "vpc_subnet" {
  value = {
    for az in aws_subnet.subnet_private:
        az.availability_zone => az.cidr_block
  }
}

output "public_ip" {
  value = {
    for az in aws_instance.ec2_server:
        az.availability_zone => az.public_ip
  }
}

output "private_ip" {
  value = {
    for az in aws_instance.ec2_server:
        az.availability_zone => az.private_ip
  }
}
