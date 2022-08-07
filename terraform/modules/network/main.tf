locals {
  internal_fw_name = join("-", [module.vpc.network_name, "allow-internal-fw"])
  https_fw_name    = join("-", [module.vpc.network_name, "wordpress-allow-https-fw"])
  http_fw_name     = join("-", [module.vpc.network_name, "wordpress-allow-http-fw"])
  ssh_fw_name      = join("-", [module.vpc.network_name, "wordpress-allow-ssh"])
  icmp_fw_name     = join("-", [module.vpc.network_name, "wordpress-allow-icmp"])
  subnetwork_cidr  = [for subnet in var.subnets : subnet.subnetwork_cidr]
}

module "vpc" {
  source  = "terraform-google-modules/network/google//modules/vpc"
  version = "5.2.0"

  project_id      = var.project_id
  network_name    = var.network_name
  shared_vpc_host = false
}

module "subnet" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "5.2.0"

  for_each = { for idx, subnet in var.subnets : idx => subnet }

  project_id   = var.project_id
  network_name = module.vpc.network_name

  subnets = [
    {
      subnet_name   = each.value.subnetwork_name
      subnet_ip     = each.value.subnetwork_cidr
      subnet_region = each.value.region
    }
  ]
  depends_on = [module.vpc.network_name]
}

module "network_firewall-rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "5.2.0"

  project_id   = var.project_id
  network_name = module.vpc.network_name

  rules = [{
    name                    = local.internal_fw_name
    description             = null
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = local.subnetwork_cidr
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "icmp"
      ports    = []
      },
      {
        protocol = "tcp"
        ports    = ["0-65535"]
      },
      {
        protocol = "udp"
        ports    = ["0-65535"]
      },
    ]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    },
    {
      name                    = local.https_fw_name
      description             = null
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = [var.https_tag]
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["443"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = local.http_fw_name
      description             = null
      direction               = "INGRESS"
      priority                = 1000
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = [var.http_tag]
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["80"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = local.ssh_fw_name
      description             = null
      direction               = "INGRESS"
      priority                = 65534
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    },
    {
      name                    = local.icmp_fw_name
      description             = null
      direction               = "INGRESS"
      priority                = 65534
      ranges                  = ["0.0.0.0/0"]
      source_tags             = null
      source_service_accounts = null
      target_tags             = null
      target_service_accounts = null
      allow = [{
        protocol = "icmp"
        ports    = []
      }]
      deny = []
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
  }]
  depends_on = [module.vpc.network_name]
}

module "public_address" {
  source  = "terraform-google-modules/address/google"
  version = "3.1.1"

  project_id   = var.project_id
  region       = var.region
  address_type = "EXTERNAL"
  names        = [var.public_address]
}

# Module cloud-nat has a bug while creating Router
resource "google_compute_router" "router" {
  name    = var.cloud_router
  project = var.project_id
  network = var.network_name
  region  = var.region
  bgp {
    asn = 64514
  }
  depends_on = [module.subnet.subnets]
}

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "2.1.0"

  project_id                         = var.project_id
  region                             = var.region
  network                            = var.network_name
  create_router                      = false
  router                             = google_compute_router.router.name
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  depends_on                         = [google_compute_router.router]
}