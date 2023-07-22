provider "aws" {
    region = "us-east-1"
}
variable "sub_sider_block" {
  description = "subnet1 sider block"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name: "dev-vpc"
    vpc_env: "dev"
  }
}

resource "aws_subnet" "dev-sub1" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = var.sub_sider_block
  availability_zone = "us-east-1b"
  tags = {
    Name: "dev-sub1"
  }
}
resource "aws_subnet" "dev-sub2" {
  vpc_id     = aws_vpc.dev-vpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name: "dev-sub2"
  }
}
