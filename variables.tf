variable "admin_cidr" {
  description = "Trusted CIDR allowed to access SSH and the n8n administration port, e.g. 203.0.113.10/32"
  type        = string

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0))
    error_message = "admin_cidr must be a valid CIDR block."
  }
}
