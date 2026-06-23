output "network_id" {
  value = vkcs_networking_network.main.id
}

output "public_subnet_id" {
  value      = vkcs_networking_subnet.public.id
  depends_on = [vkcs_networking_router_interface.public]
}

output "private_subnet_id" {
  value      = vkcs_networking_subnet.private.id
  depends_on = [vkcs_networking_router_interface.private]
}

# floating ip
output "external_network_name" {
  value = data.vkcs_networking_network.external.name
}

data "vkcs_networking_network" "external" {
  id = var.external_network_id
}