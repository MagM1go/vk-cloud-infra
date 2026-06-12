resource "vkcs_networking_secgroup" "web" {
  name = "${var.project_name}-web-sg"
}

resource "vkcs_networking_secgroup_rule" "web_ssh_from_bastion" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = vkcs_networking_secgroup.bastion.id
  security_group_id = vkcs_networking_secgroup.web.id
}

resource "vkcs_networking_secgroup_rule" "web_ssh_from_lb" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_group_id   = vkcs_networking_secgroup.lb.id
  security_group_id = vkcs_networking_secgroup.web.id
}

resource "vkcs_networking_secgroup_rule" "web_node_exporter" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = vkcs_networking_secgroup.monitoring.id
  security_group_id = vkcs_networking_secgroup.web.id
}