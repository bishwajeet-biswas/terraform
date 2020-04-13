//this module creates a vpc, a private subnetwork with primary and secondary ip ranges, along with a firewall 

variable "vpc_name" {}
variable "fire_name" {}
variable "tags" {}
variable "ip_access" {}



# resource "google_compute_network" "custom-test" {
#   name                    = var.vpc_name
#   auto_create_subnetworks = false
# }

# output "vpc_named" {
#   value = google_compute_network.custom-test.name
# }


# resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
#   name          = var.sub_name
#   ip_cidr_range = var.primary_range
#   region        = var.region
#   network       = google_compute_network.custom-test.self_link
#   secondary_ip_range {
#     range_name    = "tf-test-secondary-range-update1"
#     ip_cidr_range = var.second_range
#   }
# }

# output "subnetwork_name" {
#   value = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
# }


resource "google_compute_firewall" "firewall" {
  name    = var.fire_name
  network = var.vpc_name
  #network = google_compute_network.custom-test.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22","80", "8080", "1000-2000"]
  }

  source_tags = var.tags
  source_ranges = var.ip_access
}

