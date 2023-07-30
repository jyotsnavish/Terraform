module "initial-signalfx-integration" {
  source              = "../modules/external_id"
  integration_name    = "${var.integration_name}"
  signalfx_auth_token = "${var.signalfx_auth_token}"
  api_url    = "${var.api_url}"
}

module "aws-role-policy" {
  source           = "../modules/aws_role"
  external_id      = "${module.initial-signalfx-integration.external_id}"
  signalfx_aws_account = "${module.initial-signalfx-integration.signalfx_aws_account}"
  region           = "${var.region}"
  access_key       = "${var.access_key}"
  secret_key       = "${var.secret_key}" 
  role_name        = "${var.role_name}"
  policy_name      = "${var.policy_name}"
  policy_file      = "${file(var.policy_path)}"
  # ABSOLUTE PATH FOR POLICY FILE
}

module "final-signalfx-integration" {  
  source            = "../modules/sfx_aws_integration"
  signalfx_auth_token = "${var.signalfx_auth_token}"
  api_url    = "${var.api_url}"
  integration_id    = "${module.initial-signalfx-integration.id}"
  role_arn          = "${module.aws-role-policy.role_arn}"
  external_id       = "${module.initial-signalfx-integration.external_id}"
}

