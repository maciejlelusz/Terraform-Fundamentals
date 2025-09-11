provider "aws" {
  region  = "eu-central-1"
  access_key = var.lab_aws_key
  secret_key = var.lab_aws_secret
}

provider "random" {}

resource "random_integer" "octet" {
  max = 255
  min = 0
}

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

resource "aws_subnet" "subnet_private" {
  cidr_block = "10.0.${random_integer.octet.result}.0/24"
  vpc_id = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  tags = { pod = var.pod }
}

output "vpc_subnet" {
  value = aws_subnet.subnet_private.cidr_block
}

resource "aws_key_pair" "ec2key" {
  key_name = "publicKey-${random_integer.octet.result}"
  public_key = fileexists("~/.ssh/TerraformLab.pub") ? file("~/.ssh/TerraformLab.pub") : ""
  tags = { pod = var.pod }
}
