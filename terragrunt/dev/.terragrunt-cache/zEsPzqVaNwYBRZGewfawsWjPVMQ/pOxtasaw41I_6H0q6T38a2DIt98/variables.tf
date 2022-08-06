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

variable "project" {
  type = string
  description = "GCP project ID"
  default = "ajpisco"
}

# Variable to be used for the metadata startup script
variable "metadata_script" {
  default = "scripts/initscript.sh"
}