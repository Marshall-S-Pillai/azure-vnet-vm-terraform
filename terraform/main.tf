module "rg" {
  source   = "./modules/resource_group"
  name     = "rg-${var.name_prefix}-vnet-vm"
  location = var.location
  tags     = var.tags
}

module "network" {
  source              = "./modules/network"
  vnet_name           = "vnet-${var.name_prefix}"
  location            = module.rg.location
  resource_group_name = module.rg.name
  address_space       = var.vnet_address_space
  subnet_prefixes     = var.subnet_prefixes
  allowed_ssh_source  = var.allowed_ssh_source
  tags                = var.tags
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "vm" {
  source              = "./modules/compute"
  vm_name             = "vm-${var.name_prefix}-linux"
  location            = module.rg.location
  resource_group_name = module.rg.name
  subnet_id           = module.network.subnet_ids["vm"]
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  ssh_public_key      = tls_private_key.ssh.public_key_openssh
  tags                = var.tags
}
