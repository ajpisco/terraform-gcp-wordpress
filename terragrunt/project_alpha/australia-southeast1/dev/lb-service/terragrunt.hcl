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
  load_balancer_name = join("-", ["wordpress", local.env, "lb"])
  http_tag             = join("-", ["wordpress", "http"])
  https_tag            = join("-", ["wordpress", "https"])
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/lb"
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include {
  path = find_in_parent_folders()
}

dependency "network-service" {
  config_path = "../network-service"
}

dependency "compute-service" {
  config_path = "../compute-service"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  env = local.env
  project_id = local.project_id
  public_address     = dependency.network-service.outputs.public_address
  network_name       = dependency.network-service.outputs.network_name
  instance_group     = dependency.compute-service.outputs.instance_group
  http_tag = local.http_tag
  https_tag = local.https_tag
  load_balancer_name = local.load_balancer_name
}

