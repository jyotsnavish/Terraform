variable "region" {
    #default = "<region>"
	default = "us-east-1"
}

variable "access_key" {
    #default = "<access_key>"
	default = "AKIAZEFZE63SSGCDCRWX"
}

variable "secret_key" {
    #default = "<secret_key>"
	default = "g6qeH+/upcCRIxwVHBVwR7XLNHFi22cPuWY0fulS"
}

variable "role_name" {
	default = "sfx-aws-role"
}

variable "policy_name" {
	default = "sfx-aws-policy"
}

variable "external_id" {}


variable "signalfx_aws_account" {}

variable "policy_file" {}
