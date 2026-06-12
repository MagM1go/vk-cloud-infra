resource "vkcs_lb_loadbalancer" "app" {
  name          = "${var.project_name}-lb"
  vip_subnet_id = var.public_subnet_id
  tags          = ["lab56"]

  security_group_ids = [var.lb_sg_id]
}

resource "vkcs_lb_listener" "http" {
  name            = "${var.project_name}-listener-http"
  loadbalancer_id = vkcs_lb_loadbalancer.app.id
  protocol        = "HTTP"
  protocol_port   = 80
}

resource "vkcs_lb_pool" "http" {
  name        = "${var.project_name}-pool-http"
  listener_id = vkcs_lb_listener.http.id
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
}

resource "vkcs_lb_member" "web" {
  for_each = vkcs_compute_instance.web

  name          = "${var.project_name}-member-${each.key}"
  pool_id       = vkcs_lb_pool.http.id
  address       = each.value.access_ip_v4
  protocol_port = 80
  subnet_id     = var.private_subnet_id
}

resource "vkcs_lb_monitor" "http" {
  name           = "${var.project_name}-hm-http"
  pool_id        = vkcs_lb_pool.http.id
  type           = "HTTP"
  delay          = 10
  timeout        = 5
  max_retries    = 3
  http_method    = "GET"
  url_path       = "/"
  expected_codes = "200"
}

resource "vkcs_networking_floatingip" "lb" {
  pool = var.external_network_name
}

resource "vkcs_networking_floatingip_associate" "lb" {
  floating_ip = vkcs_networking_floatingip.lb.address
  port_id     = vkcs_lb_loadbalancer.app.vip_port_id
}
