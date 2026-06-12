resource "vkcs_networking_network" "main" {
  name           = "${var.project_name}-vpc"
  admin_state_up = true
}

resource "vkcs_networking_subnet" "public" {
  name            = "${var.project_name}-public"
  network_id      = vkcs_networking_network.main.id
  cidr            = var.public_cidr
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}

resource "vkcs_networking_subnet" "private" {
  name            = "${var.project_name}-private"
  network_id      = vkcs_networking_network.main.id
  cidr            = var.private_cidr
  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}