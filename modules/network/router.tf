resource "vkcs_networking_router" "main" {
  name                = "${var.project_name}-router"
  admin_state_up      = true
  external_network_id = var.external_network_id
}

resource "vkcs_networking_router_interface" "public" {
  router_id = vkcs_networking_router.main.id
  subnet_id = vkcs_networking_subnet.public.id
}

resource "vkcs_networking_router_interface" "private" {
  router_id = vkcs_networking_router.main.id
  subnet_id = vkcs_networking_subnet.private.id
}
