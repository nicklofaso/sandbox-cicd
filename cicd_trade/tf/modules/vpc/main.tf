locals {
  suffix       = substr(terraform.workspace, 0, 12)
  region_count = length(var.regions)
}
