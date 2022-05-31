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

#create role 
resource "aws_iam_role" "ssm_role" {
  name               = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Then parse through the list using count
resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  role       = aws_iam_role.ssm_role.name
  count      = "${length(var.iam_policy_arn)}"
  #policy_arn = "${var.iam_policy_arn[count.index]}"
  policy_arn = "${element(var.iam_policy_arn,count.index)}"
}

#ec2 creation

locals {
	imagemap = {
		"windows" = ["ami-033594f8862b03bb2", "ami-04d183ec0fdc82311","ami-0e2c8caa770b20b08"],
		"ubuntu" = ["ami-005de95e8ff495156", "ami-0c4f7023847b90238", "ami-09d56f8956ab235b3"],
		#"centos" = ["ami-02358d9f5245918a3"],
		"rhel" = ["ami-0b0af3577fe5e3532"],
    "suse" = ["ami-074c1f40d02907260", "ami-08895422b5f3aa64a"],
		"amazonlinux2" = ["ami-0022f774911c1d690"],
		
		"all" = ["ami-033594f8862b03bb2", "ami-04d183ec0fdc82311","ami-0e2c8caa770b20b08","ami-005de95e8ff495156", "ami-0c4f7023847b90238", "ami-09d56f8956ab235b3", "ami-02358d9f5245918a3", "ami-0b0af3577fe5e3532","ami-074c1f40d02907260", "ami-08895422b5f3aa64a","ami-0022f774911c1d690"]
   }
   imageList = "${lookup("${local.imagemap}", "${var.image_family}", "invalid image family")}"  
}

locals {
	imagename = {
		"windows" = ["windows2019", "windows2016","windows2022"],
		"ubuntu" = ["ubuntu18.04", "ubuntu20.04", "ubuntu22.04"],
		#"centos" = ["centos7"],
		"rhel" = ["rhel8"],
    "suse" = ["suse12SP5", "suse15SP3"],
		"amazonlinux2" = ["amznlin2"],
		
		"all" = ["windows2019", "windows2016","windows2022","ubuntu18.04", "ubuntu20.04", "ubuntu22.04", "rhel8", "suse12SP5", "suse15SP3", "amznlin2"]
   }
   imagenameList = "${lookup("${local.imagename}", "${var.image_family}", "invalid image family")}"
}

#create instnce profile
  resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.ssm_role.name
}

#Create Instance
  resource "aws_instance" "vm_instance" {
  count = "${length(local.imageList)}"
  ami     = "${element(local.imageList, count.index)}"
  availability_zone       = "us-east-1a"
  instance_type               = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  associate_public_ip_address = true
  # mention Ip address in security group for port 80,443,22
  key_name                    = "main-key"
 
#to install ssm agent (pre-installed on windows)
  user_data = <<-EOF
                #!/bin/bash
                if cat /etc/*release | grep ^NAME | grep Red; then
                sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
                elif cat /etc/*release | grep ^NAME | grep Centos; then
                sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
                elif cat /etc/*release | grep ^NAME | grep SLES; then
                sudo zypper install amazon-ssm-agent -y
                else
                echo "AMI must be windows, ubuntu or amazonlinx2 where the ssm agent is pre-installed"
                fi
                sudo systemctl enable amazon-ssm-agent
                sudo systemctl start amazon-ssm-agent
                EOF
  tags = {
    #for_each = toset(local.imagenamelist)
    #"Name" = "${var.aws_prefix}-${each.Values}"
    "Name"                = "${var.aws_prefix}-${element(local.imagenameList, count.index)}"
    "Owner"               = "${var.Owner}"
 #   "KeepInstanceRunning" = "false"
 #   "Accessibility" = "Public"
  }
}
