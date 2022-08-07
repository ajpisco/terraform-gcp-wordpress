module "sql-db_private_service_access" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/private_service_access"
  version = "11.0.0"

  project_id  = var.project_id[var.env]
  vpc_network = module.wordpress-vpc.network_name
  ip_version  = "IPV4"

}

module "sql-db_mysql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "11.0.0"

  project_id        = var.project_id[var.env]
  name              = var.db_name
  database_version  = var.database_version
  region            = var.region
  tier              = var.db_tier
  zone              = var.zone
  activation_policy = "ALWAYS"
  ip_configuration = {
    "authorized_networks" : [],
    "ipv4_enabled" : false,
    "private_network" : module.wordpress-vpc.network_id,
    "require_ssl" : null,
    "allocated_ip_range" : null
  }
  db_name           = var.product_name
  db_charset        = "utf8"
  db_collation      = "utf8_general_ci"
  user_name         = var.user_name
  user_password     = var.user_password
  module_depends_on = [module.sql-db_private_service_access]
}