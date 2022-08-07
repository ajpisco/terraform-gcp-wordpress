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
  template_name_prefix = join("-", ["wordpress", local.env, "template"])
  http_tag             = join("-", ["wordpress", "http"])
  https_tag            = join("-", ["wordpress", "https"])
  hostname             = join("-", ["wordpress", local.env])
  subnets = [{
    "subnetwork_name" : join("-", ["wordpress", local.env, "subnet"]),
    "subnetwork_cidr" : "10.0.0.0/24",
    "region" : local.region
  }]
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  source = "../../../..//modules/compute"
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../network-service", "../iam-service"]
}

dependency "network-service" {
  config_path = "../network-service"
}

dependency "iam-service" {
  config_path = "../iam-service"
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  env = local.env
  sa_email = dependency.iam-service.outputs.sa_email
  region = local.region
  project_id = local.project_id
  machine_type = "e2-micro"
  template_name_prefix = local.template_name_prefix
  http_tag = local.http_tag
  https_tag = local.https_tag
  hostname = local.hostname
  network_name = dependency.network-service.outputs.network_name
  subnet_name = local.subnets[0].subnetwork_name
}