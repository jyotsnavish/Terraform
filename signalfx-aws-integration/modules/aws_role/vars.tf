variable "region" {
    default = "<region>"
}

variable "access_key" {
    default = "<access_key>"
}

variable "secret_key" {
    default = "<secret_key>"
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
