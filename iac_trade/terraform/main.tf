terraform {
  backend "gcs" {
    bucket = "nick-cicd-sandbox-test"
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file("/Users/nlofaso/.config/gcloud/service_accounts/rational-photon-admin-account.json")
  project     = var.project
  region      = var.region
}

module "vpc" {
  source = "./vpc"

  name_prefix = var.name_prefix
  project     = var.project
  region      = var.region

  cidr_block                  = var.cidr_block
  cidr_subnetwork_width_delta = var.cidr_subnetwork_width_delta
  cidr_subnetwork_spacing     = var.cidr_subnetwork_spacing
}
