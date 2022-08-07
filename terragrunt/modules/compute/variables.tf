variable "env" {
  type        = string
  description = "Environment name"
}

variable "machine_type" {
  type        = string
  description = "Instance type to be used by compute resources"
}

variable "source_image_project" {
  type = string
  default = "debian-cloud"
}

variable "source_image" {
  type = string
  default = "debian-11-bullseye-v20220719"
}

variable "template_name_prefix" {
  type = string
}

variable "http_tag" {
  type        = string
  description = "HTTP tag to associate compute resources with network resources"
}

variable "https_tag" {
  type        = string
  description = "HTTPS tag to associate compute resources with network resources"
}

variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region to deploy resources"
}

variable "sa_email" {
  type        = string
  description = "SA email to be used by compute resources"
}

variable "hostname" {
  type        = string
  description = "Name to be used by MIG and its instances prefix"
}

variable "network_name" {
  type        = string
  description = "VPC Network name"
}

variable "subnet_name" {
  type        = string
  description = "Subnetwork name"
}