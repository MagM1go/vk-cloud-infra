output "lb_url" {
  value = "http://${module.compute.lb_floating_ip}"
}

output "lb_floating_ip" {
  value = module.compute.lb_floating_ip
}

output "bastion_floating_ip" {
  description = "SSH: ssh ubuntu@<bastion_floating_ip> -i ~/.ssh/vk-cloud-key"
  value       = module.compute.bastion_floating_ip
}

output "monitoring_floating_ip" {
  value = module.compute.monitoring_floating_ip
}

output "grafana_url" {
  value = module.compute.grafana_url
}

output "prometheus_url" {
  value = module.compute.prometheus_url
}

output "web_private_ips" {
  value = module.compute.web_private_ips
}

output "postgres_host" {
  value = module.compute.postgres_host
}
