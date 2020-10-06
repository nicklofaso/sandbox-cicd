resource "google_compute_network" "vpc" {
  name                    = "${var.name_prefix}-vpc-${local.suffix}"
  project                 = var.project
  auto_create_subnetworks = "false"

  # A global routing mode can have an unexpected impact on load balancers; always use a regional mode
  routing_mode = "REGIONAL"
}

# Cloud Router enables you to dynamically exchange routes between your Virtual Private Cloud (VPC) and on-premises networks by using Border Gateway Protocol (BGP).

resource "google_compute_router" "vpc_router" {
  name = "${var.name_prefix}-router-${local.suffix}"

  project = var.project
  region  = var.regions[0]
  network = google_compute_network.vpc.self_link

}

resource "google_compute_subnetwork" "public_subnets" {
  count = local.region_count

  name                     = "${var.name_prefix}-public-subnet-${count.index}-${local.suffix}"
  project                  = var.project
  region                   = var.regions[count.index]
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true

  ip_cidr_range = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 0)

  # TODO - do we need secondary IP addreses?

  # TODO - logging
  # https://www.terraform.io/docs/providers/google/guides/version_3_upgrade.html

}

resource "google_compute_subnetwork" "private_subnets" {
  count = local.region_count

  name                     = "${var.name_prefix}-private-subnet-${count.index}-${local.suffix}"
  project                  = var.project
  region                   = var.regions[count.index]
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true

  ip_cidr_range = cidrsubnet(var.cidr_block, var.cidr_subnetwork_width_delta, 1 * (1 + var.cidr_subnetwork_spacing))
}

resource "google_compute_router_nat" "vpc_nat" {
  name    = "${var.name_prefix}-nat-${local.suffix}"
  project = var.project
  region  = var.regions[0]
  router  = google_compute_router.vpc_router.name

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.public_subnets[0].self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
