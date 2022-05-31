variable "access_key" {
    #description = "Enter AWS access key"
    default = "AKIA52T7UHMKW6BK7BHC"
}

variable "secret_key" {
    #description = "Enter Secret Key"
    default = "7lMqwhV3gcYS7XvlEd0HANlkafrnjjOvuumxaEVe"
}

variable "role_name" {
    description = "Enter the role name"
    type = string
    #default = "SSM_Role"
}

variable "iam_policy_arn" {
  description = "IAM Policy to be attached to role"
  type = list
  default = [
"arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM" , "arn:aws:iam::aws:policy/IAMFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess" , "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", "arn:aws:iam::aws:policy/AmazonSSMFullAccess" , "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"]
}

variable "aws_prefix" {
  description = "Enter the prefix for resource creation"
  type        = string
}

variable "image_family" {
  type        = string
  description = "Enter the image family for provisioning: like windows, ubuntu, suse, rhel, amazonlinux2, all"
}

variable "Owner" {
    description = "Enter the owner tag needs to be attached with your AWS resources"
    type = string
    #default = "Jyotsna"
}