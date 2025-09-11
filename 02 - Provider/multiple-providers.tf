provider "aws" {
  region  = "eu-central-1"
  alias = "aws-prod"
}

provider "aws" {
  region  = "eu-west-1"
  alias = "aws-dev"
}
