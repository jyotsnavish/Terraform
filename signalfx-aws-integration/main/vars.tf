variable "integration_name" {
    default = "SFx-AWS-Integration"
}

variable "signalfx_auth_token" {
    default = "<your-signalfx-auth-token>"
}

variable "api_url" {
    default = "<your-signalfx-api_url>"
}
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
variable "policy_path" {
  default = "policy.json"
}
