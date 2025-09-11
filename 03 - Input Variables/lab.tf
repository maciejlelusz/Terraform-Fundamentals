provider "aws" {
  region  = "eu-central-1"
  access_key = var.lab_aws_key
  secret_key = var.lab_aws_secret
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = { pod = "POD01" }
}
