resource "vkcs_networking_secgroup" "lb" {
  name = "${var.project_name}-lb-sg"
}

resource "vkcs_networking_secgroup_rule" "lb_http" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.lb.id
}

resource "vkcs_networking_secgroup_rule" "lb_https" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = vkcs_networking_secgroup.lb.id
}