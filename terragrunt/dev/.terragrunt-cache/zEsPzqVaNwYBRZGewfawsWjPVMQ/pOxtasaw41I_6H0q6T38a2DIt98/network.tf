module "wordpress-vpc" {
    source  = "terraform-google-modules/network/google//modules/vpc"
    version = "5.2.0"

    project_id   = var.project
    network_name = "wordpress-vpc"

    shared_vpc_host = false
}

module "wordpress-subnet" {
    source  = "terraform-google-modules/network/google//modules/subnets"
    version = "5.2.0"

    project_id   = var.project
    network_name = module.wordpress-vpc.network_name

    subnets = [
        {
            subnet_name           = "wordpress-subnet"
            subnet_ip             = "10.0.0.0/24"
            subnet_region         = var.region
        }
    ]
}

module "network_firewall-rules" {
  source  = "terraform-google-modules/network/google//modules/firewall-rules"
  version = "5.2.0"

  project_id   = var.project
  network_name = module.wordpress-vpc.network_name

  rules = [{
    name                    = "wordpress-allow-internal-fw"
    description             = null
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["10.0.0.0/16"]
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
    name                    = "wordpress-allow-https-fw"
    description             = null
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["workspace-https"]
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
    name                    = "wordpress-allow-http-fw"
    description             = null
    direction               = "INGRESS"
    priority                = 1000
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = ["workspace-http"]
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
    name                    = "wordpress-allow-ssh"
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
    name                    = "wordpress-allow-icmp"
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
  
}

module "wordpress_public_address" {
  source  = "terraform-google-modules/address/google"
  version = "3.1.1"

  project_id	= var.project
  region = var.region
  address_type = "EXTERNAL"
  names = ["wordpress-public-address"]
}

# Module cloud-nat has a bug while creating Router 
# 
resource "google_compute_router" "wordpress-router" {
  name    = "wordpress-router"
  project = var.project
  region  = var.region
  network = module.wordpress-vpc.network_name
  bgp {
    asn = 64514
  }
}

module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "2.1.0"

  project_id	= var.project
  region = var.region
  network = module.wordpress-vpc.network_name
  create_router = false
  router = "wordpress-router"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}