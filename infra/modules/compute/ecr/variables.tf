variable "name" {
  type        = string
  description = "Name prefix"
}

variable "repositories" {
  type        = list(string)
  description = "List of ECR repo names (suffixes)"
}

variable "image_tag_mutability" {
  type        = string
  description = "MUTABLE or IMMUTABLE"
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Enable image scanning on push"
  default     = true
}
