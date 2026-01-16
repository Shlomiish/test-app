variable "name" {
  type        = string
  description = "Name prefix for log groups"
}

variable "retention_in_days" {
  type        = number
  description = "Log retention in days"
  default     = 14
}
