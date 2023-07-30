terraform {
  required_providers {
    signalfx = {
      source = "splunk-terraform/signalfx"
      version = "8.0.0"
    }
  }
}
provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

data "aws_iam_policy_document" "signalfx_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
#      identifiers = [signalfx_aws_external_integration.signalfx_externalId.signalfx_aws_account]
      identifiers = ["${var.signalfx_aws_account}"]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
#      values   = [signalfx_aws_external_integration.signalfx_externalId.external_id]
      values   = ["${var.external_id}"]
    }
  }
}

// This resource returns iam_role details
resource "aws_iam_role" "aws_signalfx_role" {
  name               = "${var.role_name}"
  description        = "signalfx integration to read out data and send it to signalfxs aws account"
  assume_role_policy = data.aws_iam_policy_document.signalfx_assume_policy.json
}

// This resource returns policy details
resource "aws_iam_policy" "aws_signalfx_policy" {
  name        = "${var.policy_name}"
  description = "AWS permissions required by the Splunk Observability Cloud"
  policy      = "${var.policy_file}"
}

// This resource ataches the policy to the role
resource "aws_iam_role_policy_attachment" "splunk_role_policy_attach" {
  role       = aws_iam_role.aws_signalfx_role.name
  policy_arn = aws_iam_policy.aws_signalfx_policy.arn
}
