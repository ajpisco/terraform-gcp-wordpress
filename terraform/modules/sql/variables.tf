variable "env" {
  type        = string
  description = "Environment name"
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

variable "db_name" {
  type    = string
  description = "DB instance name"
}

variable "database_version" {
  type    = string
  default = "MYSQL_5_7"
}

variable "db_tier" {
  type        = string
  description = "Instance type to be used by DB"
  default     = "db-n1-standard-1"
}

variable "network_name" {
  type        = string
  description = "VPC Network name"
}

variable "network_id" {
  type        = string
  description = "VPC Network id"
}

variable "user_name" {
  type      = string
  sensitive = true
}

variable "user_password" {
  type      = string
  sensitive = true
}