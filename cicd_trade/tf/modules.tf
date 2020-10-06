module "vpc" {
  source = "./modules/vpc"

  name_prefix = var.name_prefix
  project     = var.project
  regions     = var.regions

  cidr_block                  = var.cidr_block
  cidr_subnetwork_width_delta = var.cidr_subnetwork_width_delta
  cidr_subnetwork_spacing     = var.cidr_subnetwork_spacing
}

# module "k8s" {
#   source = "./modules/kubernetes"

#   name_prefix = var.name_prefix
#   project     = var.project
#   region      = var.regions[0]

# }

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "11.0.0"
  project_id                 = var.project
  region                     = var.regions[0]
  zones                      = var.zones
  name                       = "${var.name_prefix}-gke"
  network                    = module.vpc.network
  subnetwork                 = module.vpc.private_subnets[0]
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = var.machine_type
      min_count          = var.min_count
      max_count          = var.max_count
      disk_size_gb       = var.disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = var.service_account
      preemptible        = false
      initial_node_count = var.initial_node_count
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
