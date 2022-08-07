# terraform-gcp-wordpress

## Terraform PoC in GCP to deploy Wordpress

<br>

This script will create the following resources:
- `Service Account`: Sample SA to be used by Compute instances. Won't have any permissions because everything will be accessed through network
- `VPC`: To create our subnet and run the workloads
- `Subnet`: One subnet to for the region we are using
- `Firewall rules`: For the instances networking connections
- `External IP Address`: To be used by LB
- `Cloud Router`: To be used by Cloud NAT
- `Cloud NAT`: As we use private Compute Instances, we need NAT to connect to the internet
- `HTTP Load Balancer`: To load workload into the MIG
- `Instance template`: To set the base instance image to run
- `Managed Instance Group`: Scale the instances
- `SQL`: Mysql database

There are 2 folders in this repo: 
- `terraform`: This one uses environment variables that will set some resources name in deploy time. Example on setting env var: 
  ```bash 
  set TF_VAR_env=dev
  ```
- `terragrunt`: This one as the config files inside this folder and one folder for each environment (dev, qa and prd) in which we have a `terragrunt.hcl` file with the inputs for that specific environment 

Important - For this PoC we didn't use a Vault where we could extract sensitive data, so there are 2 variables that should be used as environment variables: TF_VAR_user_name and TF_VAR_user_password (both regarding DB details)