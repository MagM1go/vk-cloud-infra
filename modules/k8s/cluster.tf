data "vkcs_compute_flavor" "master" {
  name = var.master_flavor
}

data "vkcs_compute_flavor" "worker" {
  name = var.worker_flavor
}

resource "vkcs_kubernetes_cluster_v2" "main" {
  name        = "${var.project_name}-k8s"
  description = "Managed Kubernetes cluster"
  version     = var.k8s_version

  cluster_type       = "standard"
  master_count       = 1
  availability_zones = [var.availability_zone]
  master_flavor      = data.vkcs_compute_flavor.master.id

  network_id             = var.network_id
  subnet_id              = var.subnet_id
  loadbalancer_subnet_id = var.subnet_id
  network_plugin         = "calico"
  pods_ipv4_cidr         = "10.100.0.0/16"

  external_network_id = var.external_network_id
  public_ip           = true
}

resource "vkcs_kubernetes_node_group_v2" "workers" {
  cluster_id = vkcs_kubernetes_cluster_v2.main.id
  name       = "workers"

  node_flavor       = data.vkcs_compute_flavor.worker.id
  availability_zone = var.availability_zone

  scale_type             = "fixed_scale"
  fixed_scale_node_count = 1

  parallel_upgrade_chunk = 50

  disk_type = "ceph-ssd"
  disk_size = 20
}