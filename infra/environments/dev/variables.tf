variable "name" {
  type        = string
  description = "Project name prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "log_retention_days" {
  type        = number
  description = "CloudWatch log retention"
}

variable "ecr_repositories" {
  type = list(string)
}
