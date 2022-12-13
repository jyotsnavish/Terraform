provider "google" {
  credentials = file("playground-s-11-e316836c-8cd1ab97ca2c.json")
  project = "playground-s-11-e316836c"
  region  = "us-central1"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  name          = "vpc-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_instance" "vm_instance" {
  name         = "testvm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        name = "jyotsna"
      }
    }
  }

  network_interface {
   subnetwork = google_compute_subnetwork.vpc_subnetwork.name

    access_config {
      // Ephemeral public IP
    }
}
}

resource "google_compute_address" "vm_static_ip" {
  name = "test-static-ip"
}
