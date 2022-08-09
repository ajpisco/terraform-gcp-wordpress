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
  db_name            = join("-", ["wordpress", local.env, "db"])
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/sql"
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include {
  path = find_in_parent_folders()
}

dependency "network-service" {
  config_path = "../network-service"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  env = local.env
  zone = local.zone
  project_id = local.project_id
  network_name = dependency.network-service.outputs.network_name
  network_id       = dependency.network-service.outputs.network_id
  db_name          = local.db_name
}
  
  
  
  
  