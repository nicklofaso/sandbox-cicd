data "google_compute_subnetwork" "public_subnet" {
    self_link = var.public_subnet
}

data "google_compute_subnetwork" "private_subnet" {
    self_link = var.private_subnet
}

locals {
  suffix = substr(terraform.workspace, 0, 12)
  public = "public"
  private = "private"
  private_persistance = "private_persistance"
}

resource "google_compute_firewall" "public_allow_all_inbound" {
    name = "${var.name_prefix}-public-allow-ingress-${local.suffix}"
    project = var.project
    network = var.network

    target_tags = [local.public]
    direction = "INGRESS"
    source_ranges = ["0.0.0.0/0"]

    allow {
        protocol = "all"
    }
}

resource "google_compute_firewall" "private_allow_all_network_inbound" {
  name = "${var.name_prefix}-private-allow-network-inbound"

  project = var.project
  network = var.network

  target_tags = [local.private]
  direction   = "INGRESS"

  source_ranges = [
    data.google_compute_subnetwork.public_subnet.ip_cidr_range,
    data.google_compute_subnetwork.private_subnet.ip_cidr_range,
  ]

  allow {
    protocol = "all"
  }
}
