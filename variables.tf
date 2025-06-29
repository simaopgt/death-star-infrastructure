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

variable "command_core_service_name" {
  description = "The name of the Command Core Cloud Run service."
  type        = string
  default     = "command-core"
}

variable "command_core_image" {
  description = "The container image for the Command Core service."
  type        = string
}

variable "bridge_ui_service_name" {
  description = "The name of the Bridge UI Cloud Run service."
  type        = string
  default     = "bridge-ui"
}

variable "bridge_ui_image" {
  description = "The container image for the Bridge UI service."
  type        = string
}