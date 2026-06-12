resource "vkcs_networking_secgroup" "db" {
  name = "${var.project_name}-db-sg"
}

resource "vkcs_networking_secgroup_rule" "db_pg" {
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = vkcs_networking_secgroup.web.id
  security_group_id = vkcs_networking_secgroup.db.id
}