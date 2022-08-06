variable "env" {
  type = string
}

variable "region" {
    type = string
    description = "GCP region to deploy resources"
    default = "australia-southeast1"
}

variable "zone" {
    type = string
    description = "GCP zone to deploy resources"
    default = "australia-southeast1-b"
}

variable "project_id" {
  type = string
  description = "GCP project ID"
  default = "ajpisco"
}

variable "metadata_script" {
  description = "Variable to be used for the metadata startup script"
  default = "scripts/initscript.sh"
}

variable "network_name" {
  type = string
  default = "wordpress-vpc"
}

variable "subnetwork_name" {
  type = string
  default = "wordpress-subnet"
}

variable "subnetwork_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "http_tag" {
  type = string
  default = "wordpress-http"
}

variable "https_tag" {
  type = string
  default = "wordpress-https"
}

variable "cloud_router" {
  type = string
  default = "wordpress-router"
}

variable "load_balancer_name" {
  type = string
  default = "wordpress-lb"
}

variable "machine_type" {
  type = string
  default = "e2-medium"
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
  default = "wordpress-template"
}

variable "product_name" {
  type = string
  default = "wordpress"
}