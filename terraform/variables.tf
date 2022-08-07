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
  type        = string
  description = "GCP project ID"
}

variable "metadata_script" {
  description = "Variable to be used for the metadata startup script"
  default     = "scripts/initscript.sh"
}

variable "primary_subnet_cidr" {
  type        = string
  description = "Primary CIDR block to use in Subnet"
  default     = "10.0.0.0/24"
}

variable "http_tag" {
  type    = string
  default = "http"
}

variable "https_tag" {
  type    = string
  default = "https"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "product_name" {
  type    = string
  default = "wordpress"
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
  type        = string
  description = "Instance type to be used by DB"
  default     = "db-n1-standard-1"
}

variable "database_version" {
  type    = string
  default = "MYSQL_5_7"
}