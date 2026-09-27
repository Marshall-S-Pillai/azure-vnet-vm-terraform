output "resource_group_name" {
  value = module.rg.name
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "vm_name" {
  value = module.vm.vm_name
}

output "vm_public_ip" {
  value = module.vm.public_ip
}

output "vm_private_ip" {
  value = module.vm.private_ip
}

output "admin_username" {
  value = module.vm.admin_username
}

output "ssh_private_key_pem" {
  description = "Generated SSH private key. Sensitive. Save locally and do not commit."
  value       = tls_private_key.ssh.private_key_pem
  sensitive   = true
}

output "ssh_public_key" {
  value = tls_private_key.ssh.public_key_openssh
}

output "ssh_connect_command" {
  value = "ssh -i ./id_rsa ${module.vm.admin_username}@${module.vm.public_ip}"
}
