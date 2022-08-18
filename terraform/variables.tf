variable "project_id" {
  description = "Id of the project in which to deploy."
  type = string
}

variable "region" {
  description = "Zone where resources are instantiated." 
  type = string
  default = "europe-west1"
}

variable "connector_name" {
  description = "Name of the VPC connector used for the Cloud Function."
  type = string
  default = "my-cf-connector"
}

variable "cf_name" {
  description = "Name of the Cloud Function."
  type = string
  default = "my-cf"
}

variable "terraform_provisioning_sa_name" {
  description = "Name of the service account used to provision Terraform."
  type = string
  default = "terraform-deployer"
}

variable "cloud_function_sa_name" {
  description = "Name of the service account used by the Cloud Function."
  type = string
  default = "cloud-function-sa"
}
