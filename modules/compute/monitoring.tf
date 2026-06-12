resource "vkcs_compute_instance" "monitoring" {
  name              = "${var.project_name}-monitoring"
  flavor_id         = data.vkcs_compute_flavor.monitoring.id
  key_pair          = var.keypair_name
  availability_zone = var.availability_zone
  security_groups   = [var.monitoring_sg_name]

  block_device {
    uuid                  = data.vkcs_images_image.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 20
    volume_type           = "ceph-ssd"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.network_id
  }

  user_data = templatefile("${path.module}/files/cloud-init/monitoring.yaml", {
    node_targets = concat(
      ["localhost:9100", "${vkcs_compute_instance.bastion.access_ip_v4}:9100"],
      [for w in vkcs_compute_instance.web : "${w.access_ip_v4}:9100"]
    )
    tg_bot_token = var.tg_bot_token
    tg_chat_id   = var.tg_chat_id
  })

  depends_on = [vkcs_compute_instance.web, vkcs_compute_instance.bastion]
}

resource "vkcs_networking_floatingip" "monitoring" {
  pool = var.external_network_name
}

resource "vkcs_compute_floatingip_associate" "monitoring" {
  floating_ip = vkcs_networking_floatingip.monitoring.address
  instance_id = vkcs_compute_instance.monitoring.id
}