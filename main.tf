provider "aws" {
    region = "us-east-1"
}
variable sub_sider_block {}
variable vpc_sider_block {}
variable avail_zone {}
variable env_prefix {}
variable my_ip {}
variable instance_type {}
resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_sider_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}
resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
resource "aws_subnet" "myapp-sub1" {
  vpc_id     = aws_vpc.myapp-vpc.id
  cidr_block = var.sub_sider_block
  availability_zone = "us-east-1b"
  tags = {
    Name: "${var.env_prefix}-sub1"
  }
}
resource "aws_route_table" "myapp-rout-table" {
  vpc_id = aws_vpc.myapp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-route-table"
  }
}
resource "aws_route_table_association" "myapp-rta" {
  subnet_id      = aws_subnet.myapp-sub1.id
  route_table_id = aws_route_table.myapp-rout-table.id
}

resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  vpc_id      = aws_vpc.myapp-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }
  ingress {
    description      = "TLS from outside"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-sg"
  }
}
data "aws_ami" "iam" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.iam.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.myapp-sub1.id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = "terraform"
  user_data = <<EOF
                    #!/bin/bash
                    sudo yum -y update
                    sudo yum install -y docker
                    sudo systemctl start docker 
                    sudo usermod -aG docker ec2-user
                    docker run -p 8080:80 nginx 
              EOF
  tags = {
    Name = "${var.env_prefix}-server"
  }
}
