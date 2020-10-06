locals {
  suffix = substr(terraform.workspace, 0, 12)
}

resource "google_compute_network" "vpc" {
  name = "${var.name_prefix}-vpc-${local.suffix}"
  project = var.project
  auto_create_subnetworks = "false"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

# Cloud Router enables you to dynamically exchange routes between your Virtual Private Cloud (VPC) and on-premises networks by using Border Gateway Protocol (BGP).

resource "google_compute_router" "vpc_router" {
  name = "${var.name_prefix}-router-${local.suffix}"

  project = var.project
  region  = var.region
  network = google_compute_network.vpc.self_link

}

resource "google_compute_subnetwork" "vpc_subnet_public" {
  name = "${var.name_prefix}-public-subnet-${local.suffix}"
  project = var.project
  region = var.region
  network = google_compute_network.vpc.self_link
  private_ip_google_access = true

  ip_cidr_range = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 0)

  # TODO - do we need secondary IP addreses?

  # TODO - logging
  # https://www.terraform.io/docs/providers/google/guides/version_3_upgrade.html

}

resource "google_compute_router_nat" "vpc_nat" {
  name = "${var.name_prefix}-nat-${local.suffix}"
  project = var.project
  region = var.region
  router = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.vpc_subnet_public.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

resource "google_compute_subnetwork" "vpc_subnet_private" {
  name = "${var.name_prefix}-private-subnet-${local.suffix}"
  project = var.project
  region = var.region
  network = google_compute_network.vpc.self_link
  private_ip_google_access = true

  ip_cidr_range            = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 1 * (1 + var.cidr_subnetwork_spacing))
}


module "network_firewall" {
  source = "../firewall"

  name_prefix = var.name_prefix

  project = var.project
  network = google_compute_network.vpc.self_link

  public_subnet  = google_compute_subnetwork.vpc_subnet_public.self_link
  private_subnet = google_compute_subnetwork.vpc_subnet_private.self_link
}
