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

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  cidr = "10.0.0.0/16"

  azs             = [ "eu-central-1a" ]
  public_subnets  = ["10.0.${random_integer.octet.result}.0/24"]

}
