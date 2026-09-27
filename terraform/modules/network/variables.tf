variable "vnet_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type = list(string)
}

variable "subnet_prefixes" {
  type = map(string)
}

variable "allowed_ssh_source" {
  type    = string
  default = "*"
}

variable "tags" {
  type    = map(string)
  default = {}
}
