
include "env" {
  path = "../../../../_env/iam.hcl"
}

# Include all settings from the root terragrunt.hcl file (backend herited here)
include "root" {
  path = find_in_parent_folders()
}

inputs = {
}