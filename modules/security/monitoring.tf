resource "vkcs_networking_secgroup" "monitoring" {
  name = "${var.project_name}-monitoring-sg"
}

resource "vkcs_networking_secgroup_rule" "monitoring_ssh" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.my_ip
  security_group_id = vkcs_networking_secgroup.monitoring.id
}

resource "vkcs_networking_secgroup_rule" "monitoring_grafana" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = var.my_ip
  security_group_id = vkcs_networking_secgroup.monitoring.id
}

resource "vkcs_networking_secgroup_rule" "monitoring_prometheus" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 9090
  port_range_max    = 9090
  remote_ip_prefix  = var.my_ip
  security_group_id = vkcs_networking_secgroup.monitoring.id
}

resource "vkcs_networking_secgroup_rule" "monitoring_alertmanager" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 9093
  port_range_max    = 9093
  remote_ip_prefix  = var.my_ip
  security_group_id = vkcs_networking_secgroup.monitoring.id
}