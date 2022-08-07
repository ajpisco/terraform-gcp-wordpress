variable "env" {
  type = string
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources"
  default     = "australia-southeast1"
}

variable "zone" {
  type        = string
  description = "GCP zone to deploy resources"
  default     = "australia-southeast1-b"
}

variable "project_id" {
  type        = map(any)
  description = "GCP project ID"
  default = {
    "dev" : "ajpisco",
    "qa" : "ajpisco",
    "prd" : "ajpisco",
  }
}

variable "metadata_script" {
  description = "Variable to be used for the metadata startup script"
  default     = "scripts/initscript.sh"
}

variable "network_name" {
  type    = string
  default = "wordpress-vpc"
}

variable "subnetwork_name" {
  type    = string
  default = "wordpress-subnet"
}

variable "subnetwork_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "http_tag" {
  type    = string
  default = "wordpress-http"
}

variable "https_tag" {
  type    = string
  default = "wordpress-https"
}

variable "cloud_router" {
  type    = string
  default = "wordpress-router"
}

variable "load_balancer_name" {
  type    = string
  default = "wordpress-lb"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "source_image_project" {
  type    = string
  default = "debian-cloud"
}

variable "source_image" {
  type    = string
  default = "debian-11-bullseye-v20220719"
}

variable "template_name_prefix" {
  type    = string
  default = "wordpress-template"
}

variable "product_name" {
  type    = string
  default = "wordpress"
}

variable "public_address" {
  type    = string
  default = "wordpress-public-address"
}

variable "db_name" {
  type    = string
  default = "wordpress-db"
}

variable "user_name" {
  type      = string
  sensitive = true
}

variable "user_password" {
  type      = string
  sensitive = true
}

variable "db_tier" {
  type    = string
  default = "db-n1-standard-1"
}

variable "database_version" {
  type    = string
  default = "MYSQL_5_7"
}