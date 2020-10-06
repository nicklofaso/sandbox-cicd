module "network_firewall" {
  source = "../firewall"

  name_prefix = var.name_prefix

  project = var.project
  network = google_compute_network.vpc.self_link

  public_subnets  = google_compute_subnetwork.public_subnets.*.self_link
  private_subnets = google_compute_subnetwork.private_subnets.*.self_link
}
