#download aws provider
provider "aws" {

region="us-east-1"

}

terraform {
  required_version=">=0.12"
  backend "s3" {
    bucket="myapp-bucket"
    key ="terraform.tfstate"
    region ="us-east-1"
  }

}