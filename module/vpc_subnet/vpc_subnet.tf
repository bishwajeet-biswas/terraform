// This will create vpc and subnet

variable "vpc_name" {}
variable "sub_name" {}
variable "primary_range" {}
variable "region" {}
variable "second_range" {}




resource "google_compute_network" "custom-test" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}



resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = var.sub_name
  ip_cidr_range = var.primary_range
  region        = var.region
  network       = google_compute_network.custom-test.self_link
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = var.second_range
  }
}

// outputs

output "vpc_named" {
  value = google_compute_network.custom-test.name
}


output "subnetwork_named" {
  value = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
}
