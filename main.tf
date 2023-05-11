provider "aws" {
region="us-east-1"
  
}

resource "aws_vpc" "vpc-example"{
    cidr_block       = "10.0.0.0/16"
}

variable "avail_zone" {
  
}

resource "aws_subnet" "sub-example"{
   vpc_id = aws_vpc.vpc-example.id
   cidr_block = "10.0.10.0/24"
   availability_zone =var.avail_zone
}

