provider "aws" {
  region  = "eu-central-1"
  access_key = var.lab_aws_key
  secret_key = var.lab_aws_secret
}

provider "random" {}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = var.pod }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = { pod = var.pod }
}

resource "random_integer" "octet" {
  max = 255
  min = 0
}

resource "aws_subnet" "subnet_private" {
  cidr_block = "10.0.${random_integer.octet.result}.0/25"
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}

output "vpc_subnet" {
  value = aws_subnet.subnet_private.cidr_block
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
  subnet_id      = aws_subnet.subnet_private.id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_instance" "ec2_server" {
  ami           = "ami-0c960b947cbb2dd16"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_private.id
  vpc_security_group_ids = [aws_security_group.sg_any.id]
  key_name = aws_key_pair.ec2key.key_name
  tags = { pod = var.pod }
  count = 2
}

output "public_ip" {
  value = aws_instance.ec2_server.*.public_ip
}

output "private_ip" {
  value = aws_instance.ec2_server.*.private_ip
}

output "public_ip_instance_0" {
  value = "Adres IP instancji z indeksem 0 to ${element(aws_instance.ec2_server.*.public_ip, 0)}"
}
