provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/root/.aws/credentials"]
}
locals {
  instance_name = "${terraform.workspace}-instance"
  project = "Test"
}

resource "aws_instance" "ec2_example" {
  ami = "ami-053b0d53c279acc90"
  instance_type = var.instance_type

  tags = {
    Name = local.instance_name
    Project = local.project
  }
}
