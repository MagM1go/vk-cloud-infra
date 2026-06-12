output "bastion_sg_id" {
  value = vkcs_networking_secgroup.bastion.id
}

output "bastion_sg_name" {
  value = vkcs_networking_secgroup.bastion.name
}

output "web_sg_id" {
  value = vkcs_networking_secgroup.web.id
}

output "web_sg_name" {
  value = vkcs_networking_secgroup.web.name
}

output "lb_sg_id" {
  value = vkcs_networking_secgroup.lb.id
}

output "lb_sg_name" {
  value = vkcs_networking_secgroup.lb.name
}

output "db_sg_id" {
  value = vkcs_networking_secgroup.db.id
}

output "monitoring_sg_id" {
  value = vkcs_networking_secgroup.monitoring.id
}

output "monitoring_sg_name" {
  value = vkcs_networking_secgroup.monitoring.name
}