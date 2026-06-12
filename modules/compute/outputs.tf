output "bastion_floating_ip" {
  value = vkcs_networking_floatingip.bastion.address
}

output "monitoring_floating_ip" {
  value = vkcs_networking_floatingip.monitoring.address
}

output "web_private_ips" {
  value = { for k, w in vkcs_compute_instance.web : k => w.access_ip_v4 }
}

output "web_instance_ids" {
  value = { for k, w in vkcs_compute_instance.web : k => w.id }
}

output "postgres_host" {
  value = vkcs_db_instance.postgres.ip
}

output "lb_floating_ip" {
  value = vkcs_networking_floatingip.lb.address
}

output "grafana_url" {
  value = "http://${vkcs_networking_floatingip.monitoring.address}:3000"
}

output "prometheus_url" {
  value = "http://${vkcs_networking_floatingip.monitoring.address}:9090"
}
