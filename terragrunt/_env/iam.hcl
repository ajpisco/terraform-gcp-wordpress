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
  sa_account_id        = join("-", ["wordpress", local.env, "sa"])
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/iam"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  sa_account_id = local.sa_account_id
  project_id = local.project_id
}