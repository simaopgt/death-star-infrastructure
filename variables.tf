variable "project_id" {
  description = "The ID of the GCP project."
  type        = string
}

variable "region" {
  description = "The GCP region to deploy resources into."
  type        = string
  default     = "us-central1"
}

variable "vpc_network_name" {
  description = "The name of the VPC network."
  type        = string
  default     = "death-star-vpc"
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "death-star-main-subnet"
}

variable "subnet_ip_cidr_range" {
  description = "The IP CIDR range for the subnet."
  type        = string
  default     = "10.0.0.0/24"
}
