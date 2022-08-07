locals {
  sa_account_id        = join("-", [var.product_name, var.env, "sa"])
  http_tag             = join("-", [var.product_name, var.http_tag])
  https_tag            = join("-", [var.product_name, var.https_tag])
  hostname             = join("-", [var.product_name, var.env])
  template_name_prefix = join("-", [var.product_name, var.env, "template"])
  network_name         = join("-", [var.product_name, var.env, "vpc"])
  subnets = [{
    "subnetwork_name" : join("-", [var.product_name, var.env, "subnet"]),
    "subnetwork_cidr" : var.primary_subnet_cidr,
    "region" : var.region
  }]
  public_address     = join("-", [var.product_name, var.env, "public-address"])
  db_name            = join("-", [var.product_name, var.env, "db"])
  load_balancer_name = join("-", [var.product_name, var.env, "lb"])
  cloud_router = join("-", [var.product_name, var.env, "router"])
}

module "iam" {
  source = "./modules/iam"

  sa_account_id = local.sa_account_id
}

module "network" {
  source = "./modules/network"

  env            = var.env
  region         = var.region
  project_id     = var.project_id
  cloud_router   = local.cloud_router
  subnets        = local.subnets
  network_name   = local.network_name
  public_address = local.public_address
  http_tag       = local.http_tag
  https_tag      = local.https_tag

}

module "compute" {
  source = "./modules/compute"

  env                  = var.env
  sa_email             = module.iam.sa_email
  region               = var.region
  project_id           = var.project_id
  machine_type         = var.machine_type
  template_name_prefix = local.template_name_prefix
  http_tag             = local.http_tag
  https_tag            = local.https_tag
  hostname             = local.hostname
  network_name         = module.network.network_name
  subnet_name          = local.subnets[0].subnetwork_name
  depends_on           = [module.network.network_name, module.network.subnets, module.iam.sa_email]

}

module "lb" {
  source = "./modules/lb"

  env                = var.env
  project_id         = var.project_id
  public_address     = module.network.public_address
  network_name       = module.network.network_name
  instance_group     = module.compute.instance_group
  http_tag           = local.http_tag
  https_tag          = local.https_tag
  load_balancer_name = local.load_balancer_name
  depends_on         = [module.compute.instance_group, module.network.network_id, module.network.public_address]
}

module "sql" {
  source = "./modules/sql"

  env              = var.env
  project_id       = var.project_id
  network_name     = module.network.network_name
  network_id       = module.network.network_id
  db_name          = local.db_name
  user_name        = var.user_name
  user_password    = var.user_password
  db_tier          = var.db_tier
  database_version = var.database_version
  depends_on       = [module.network.network_id, module.network.network_name]
}