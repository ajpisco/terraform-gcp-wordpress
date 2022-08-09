locals {
  # Automatically load parent-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project_vars = read_terragrunt_config(find_in_parent_folders("project.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.env
  region = local.region_vars.locals.region
  project_id = local.project_vars.locals.project_id
  
  # Set local variables to be used
  http_tag             = join("-", ["wordpress", "http"])
  https_tag            = join("-", ["wordpress", "https"])
  subnets = [{
    "subnetwork_name" : join("-", ["wordpress", local.env, "subnet"]),
    "subnetwork_cidr" : "10.0.0.0/24",
    "region" : local.region
  }]
  cloud_router     = join("-", ["wordpress", local.env, "router"])
  public_address     = join("-", ["wordpress", local.env, "public-address"])
  network_name         = join("-", ["wordpress", local.env, "vpc"])
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/network"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  env = local.env
  region = local.region
  project_id = local.project_id
  cloud_router   = local.cloud_router
  subnets        = local.subnets
  network_name   = local.network_name
  public_address = local.public_address
  http_tag       = local.http_tag
  https_tag      = local.https_tag
}