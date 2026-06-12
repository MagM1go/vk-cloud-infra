locals {
  web_nodes = toset(["1", "2"])
}

resource "vkcs_compute_instance" "web" {
  for_each = local.web_nodes

  name              = "${var.project_name}-web-${each.key}"
  flavor_id         = data.vkcs_compute_flavor.web.id
  key_pair          = var.keypair_name
  availability_zone = var.availability_zone
  security_groups   = [var.web_sg_name]

  block_device {
    uuid                  = data.vkcs_images_image.golden.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 10
    volume_type           = "ceph-ssd"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.network_id
  }

  user_data = templatefile("${path.module}/files/cloud-init/web.yaml", {
    hostname = "${var.project_name}-web-${each.key}"
  })
}