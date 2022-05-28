terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region  = "us-east-1"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}


#Create VPC
resource "aws_vpc" "main-vpc"{
   cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Main-VPC"
    Owner = "${var.Owner}"
  }
}

#Create Internet Gateway
resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "Main-Gateway"
    Owner = "${var.Owner}"
  }
}

#Create Route Table
resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.main-gateway.id
  }

  tags = {
    Name = "Main-RouteTable"
    Owner = "${var.Owner}"
  }
}

#Create subnet
resource "aws_subnet" "main-subnet" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Main-Subnet"
    Owner = "${var.Owner}"
  }
}

#Associate subnet with route table
resource "aws_route_table_association" "subnet_rt" {
  subnet_id      = aws_subnet.main-subnet.id
  route_table_id = aws_route_table.main-rt.id
}

#Create Security group to allow port 22,80,443
resource "aws_security_group" "sgroup" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description      = "HTTPS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
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
    Name = "allow_tls"
  }
}


#7. Create a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "ni" {
  subnet_id       = aws_subnet.main-subnet.id
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.sgroup.id]
}


#8. Assign an elastic ip to the network interface created in step 7
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.ni.id
  associate_with_private_ip = "10.0.1.10"
  depends_on                = [aws_internet_gateway.main-gateway]

}


#9. Create server and install/enable apache2


resource "aws_instance" "instance_server" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"
  key_name = "main-key"
  availability_zone = "us-east-1a"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.ni.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                EOF

  tags = {
    Name = "Amazon_Linux2"
    Owner = "${var.Owner}"
  }
}
