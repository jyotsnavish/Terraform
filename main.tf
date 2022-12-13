module "google" {
  credentials = var.account_file_variable
  project = var.project
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}