terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = "8.0.0"
    }
  }
}
provider "signalfx" {
  auth_token = "${var.signalfx_auth_token}"
  # If your organization uses a different realm
  api_url = "${var.api_url}"
}

// This resource returns an account id in `external_id`
resource "signalfx_aws_external_integration" "signalfx_externalId" {
  name = "${var.integration_name}"
}

