output "network_id" {
  value = vkcs_networking_network.main.id
}

output "public_subnet_id" {
  value = vkcs_networking_subnet.public.id
}

output "private_subnet_id" {
  value = vkcs_networking_subnet.private.id
}

# floating ip
output "external_network_name" {
  value = data.vkcs_networking_network.external.name
}

data "vkcs_networking_network" "external" {
  id = var.external_network_id
}