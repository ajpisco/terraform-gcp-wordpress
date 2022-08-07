variable "env" {
  type        = string
  description = "Environment name"
}

variable "load_balancer_name" {
  type = string
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "http_tag" {
  type = string
}

variable "https_tag" {
  type = string
}

variable "network_name" {
  type        = string
  description = "VPC Network name"
}

variable "public_address" {
  type        = string
  description = "Public address"
}

variable "instance_group" {
  type        = string
  description = "Instance group"
}