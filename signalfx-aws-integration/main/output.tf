output "external_id" {
  value = "${module.initial-signalfx-integration.external_id}"
  sensitive   = true
}


output "name" {
  value = "${module.initial-signalfx-integration.name}"
}

output "id" {
  value = "${module.initial-signalfx-integration.id}"
}

output "role_arn" {
  value = "${module.aws-role-policy.role_arn}"
}
