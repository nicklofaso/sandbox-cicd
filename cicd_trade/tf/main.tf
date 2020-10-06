terraform {
  backend "gcs" {
    bucket = "nick-cicd-sandbox-test"
    prefix = "terraform/state"
  }
}

provider "google" {
  credentials = file(var.google_credentials)
  project     = var.project
  region      = var.regions[0]
}
