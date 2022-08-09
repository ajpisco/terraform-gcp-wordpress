# terraform-gcp-wordpress

## Terraform PoC in GCP to deploy Wordpress

<br>

This script will create the following resources:
- `Service Account`: Sample SA to be used by Compute instances (This one needs to be done without Google's module because it has some bugs regarding Service account adding permissions)
- `VPC`: To create our subnet and run the workloads
- `Subnet`: One subnet to for the region we are using
- `Firewall rules`: For the instances networking connections
- `External IP Address`: To be used by LB
- `Cloud Router`: To be used by Cloud NAT
- `Cloud NAT`: As we use private Compute Instances, we need NAT to connect to the internet
- `HTTP Load Balancer`: To load workload into the MIG (This one needs to be done without Google's module because it doesn't support TCP Healthchecks)
- `Instance template`: To set the base instance image to run
- `Managed Instance Group`: Scale the instances
- `SQL`: Mysql database

There are 2 folders in this repo: 
- `terraform`: This one uses environment variables or the terraform.tfvars in deploy time. Example on setting env var: 
```bash 
env = "<environment-name>"
project_id = "<project-id>"
```
- `terragrunt`: uses the following structure:
```
📦terragrunt
 ┣ 📂modules
 ┃ ┣ 📂compute
 ┃ ┣ 📂iam
 ┃ ┣ 📂lb
 ┃ ┣ 📂network
 ┃ ┗ 📂sql
 ┣ 📂project_alpha
 ┃ ┣ 📂australia-southeast1
 ┃ ┃ ┣ 📂dev
 ┃ ┃ ┃ ┣ 📂compute-service
 ┃ ┃ ┃ ┃ ┗ 📜terragrunt.hcl
 ┃ ┃ ┃ ┣ 📂iam-service
 ┃ ┃ ┃ ┃ ┗ 📜terragrunt.hcl
 ┃ ┃ ┃ ┣ 📂lb-service
 ┃ ┃ ┃ ┃ ┗ 📜terragrunt.hcl
 ┃ ┃ ┃ ┣ 📂network-service
 ┃ ┃ ┃ ┃ ┗ 📜terragrunt.hcl
 ┃ ┃ ┃ ┗ 📜env.hcl
 ┃ ┃ ┗ 📜region.hcl
 ┃ ┗ 📜project.hcl
 ┣ 📂project_beta
 ┗ 📜terragrunt.hcl
  ``` 




Note: To avoid having Terragrunt throwing a "Filename too long" set environment variable TERRAGRUNT_DOWNLOAD to a different path: Example TERRAGRUNT_DOWNLOAD==C:\.terragrunt-cache

Note 2: While running the Plan command without the resources applied (for example in the first plan), it might return an error in SQL module because it uses a data block which will look for existing network resource that have not been applied yet and thus, returns an error. Nevertheless, when we run the Apply command everything is applied