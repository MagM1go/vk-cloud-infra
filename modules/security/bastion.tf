resource "vkcs_networking_secgroup" "bastion" {
  name = "${var.project_name}-bastion-sg"
}

resource "vkcs_networking_secgroup_rule" "bastion_ssh" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.my_ip
  security_group_id = vkcs_networking_secgroup.bastion.id
}

resource "vkcs_networking_secgroup_rule" "bastion_node_exporter" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_group_id   = vkcs_networking_secgroup.monitoring.id
  security_group_id = vkcs_networking_secgroup.bastion.id
}