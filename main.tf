provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ip_address}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name = "main"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.r.id}"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"] # Canonical

  filter {
    name   = "image-id"
    values = ["ami-0ff21806645c5e492"]
  }

}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.amazon_linux.id}"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.main.id}"
  vpc_security_group_ids  = ["${aws_security_group.allow_tls.id}"]
  associate_public_ip_address = true

  tags = {
    Name = "HelloWorld"
  }
}