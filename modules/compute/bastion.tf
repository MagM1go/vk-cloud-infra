resource "vkcs_compute_instance" "bastion" {
  name              = "${var.project_name}-bastion"
  flavor_id         = data.vkcs_compute_flavor.bastion.id
  key_pair          = var.keypair_name
  availability_zone = var.availability_zone

  block_device {
    uuid                  = data.vkcs_images_image.ubuntu.id
    source_type           = "image"
    destination_type      = "volume"
    volume_size           = 10
    volume_type           = "ceph-ssd"
    boot_index            = 0
    delete_on_termination = true
  }

  network {
    uuid = var.network_id
    port = vkcs_networking_port.bastion.id
  }

  user_data = file("${path.module}/files/cloud-init/node-exporter.yaml")
}

resource "vkcs_networking_port" "bastion" {
  network_id         = var.network_id
  security_group_ids = [var.bastion_sg_id]

  fixed_ip {
    subnet_id = var.public_subnet_id
  }
}

resource "vkcs_networking_floatingip" "bastion" {
  pool = var.external_network_name
}

resource "vkcs_networking_floatingip_associate" "bastion" {
  port_id     = vkcs_networking_port.bastion.id
  floating_ip = vkcs_networking_floatingip.bastion.address
}
