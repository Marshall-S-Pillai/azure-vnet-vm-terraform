variable "subscription_id" {
  description = "Azure subscription ID. Leave empty to use the logged-in CLI / ARM_SUBSCRIPTION_ID env var."
  type        = string
  default     = ""
}

variable "use_oidc" {
  description = "Set true in GitHub Actions. Leave false for local az login."
  type        = bool
  default     = false
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central India"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "demo"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "subnet_prefixes" {
  type = map(string)
  default = {
    vm = "10.10.1.0/24"
  }
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "allowed_ssh_source" {
  description = "CIDR allowed to SSH. Use your public IP/32 in production."
  type        = string
  default     = "*"
}

variable "tags" {
  type = map(string)
  default = {
    project    = "azure-vnet-vm"
    managed_by = "terraform"
  }
}
