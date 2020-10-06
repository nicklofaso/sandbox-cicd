data "google_compute_subnetwork" "public_subnets" {
  count     = length(var.public_subnets)
  self_link = var.public_subnets[count.index]
}

data "google_compute_subnetwork" "private_subnets" {
  count = length(var.private_subnets)

  self_link = var.private_subnets[count.index]
}

locals {
  suffix              = substr(terraform.workspace, 0, 12)
  public              = "public"
  private             = "private"
  private_persistance = "private_persistance"
}
