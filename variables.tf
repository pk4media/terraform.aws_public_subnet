variable "name" {
  default     = "public"
  description = "Subnet name"
}

variable "environment" {
  default     = "development"
  description = "Environment (development, staging, production)"
}

variable "vpc_id" {
  description = "ID of the VPC to create the Subnets in"
}

variable "cidrs" {
  description = "Comma-separated list of cidrs for the Subnets"
}

variable "availability_zones" {
  description = "Comma-separated list of availability zones for the Subnets (must be same length as cidrs)"
}
