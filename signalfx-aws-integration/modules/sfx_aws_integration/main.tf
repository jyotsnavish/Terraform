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

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command     = "sleep 20"
    interpreter = ["/bin/bash", "-c"]
    #command     = "Start-Sleep 20"
    #interpreter = ["PowerShell", "-Command"]
 }
  triggers = {
    "after" = var.role_arn
     }
}

resource "signalfx_aws_integration" "aws_sfx_integration" {
  enabled = true
  depends_on = [null_resource.delay]
  integration_id = "${var.integration_id}"
  external_id    = "${var.external_id}"
  role_arn       = "${var.role_arn}"
  regions            = ["us-east-1"]
  poll_rate          = 300
  import_cloud_watch = true
  enable_aws_usage   = true
}
