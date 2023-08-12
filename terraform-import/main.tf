provider "aws" {
  region     = "us-east-1"
}
#terraform import aws_instance.ec2_example i-0da03a2175ebc78f6
#terraform show
resource "aws_instance" "ec2_example" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  tags = {
    "Name" = "terraform"
  }
}
