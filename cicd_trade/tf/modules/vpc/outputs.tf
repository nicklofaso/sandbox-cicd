output "network" {
  value = google_compute_network.vpc.name
}

output "public_subnets" {
  value = google_compute_subnetwork.public_subnets.*.name
}

output "private_subnets" {
  value = google_compute_subnetwork.private_subnets.*.name
}
