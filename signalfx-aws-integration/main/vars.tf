variable "integration_name" {
    default = "SFx-AWS-Integration"
}

variable "signalfx_auth_token" {
    #default = "<your-signalfx-auth-token>"
	default = "vuG1h6031UTGdSCo2zO0-g"
}

variable "api_url" {
    #default = "<your-signalfx-api_url>"
	default = "https://api.us1.signalfx.com"
}
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
variable "policy_path" {
  default = "policy.json"
}
