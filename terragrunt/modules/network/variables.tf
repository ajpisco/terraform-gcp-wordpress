variable "env" {
  type        = string
  description = "Environment name"
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources"
}

variable "cloud_router" {
  type = string
  description = "Cloud router name"
}

variable "network_name" {
  type        = string
  description = "VPC Network name"
}

variable "subnets" {
  type = list(object({
    subnetwork_name = string
    subnetwork_cidr = string
    region          = string
  }))
  description = "List of subnets details to create"
}

variable "http_tag" {
  type        = string
  description = "HTTP tag to associate compute resources with network resources"
}

variable "https_tag" {
  type        = string
  description = "HTTPS tag to associate compute resources with network resources"
}

variable "public_address" {
  type        = string
  description = "Public address resource name"
}