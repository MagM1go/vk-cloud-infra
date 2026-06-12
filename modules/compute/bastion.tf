resource "vkcs_compute_instance" "bastion" {
  name              = "${var.project_name}-bastion"
  flavor_id         = data.vkcs_compute_flavor.bastion.id
  key_pair          = var.keypair_name
  availability_zone = var.availability_zone
  security_groups   = [var.bastion_sg_name]

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
  }

  user_data = file("${path.module}/files/cloud-init/node-exporter.yaml")
}

resource "vkcs_networking_floatingip" "bastion" {
  pool = var.external_network_name
}

resource "vkcs_compute_floatingip_associate" "bastion" {
  floating_ip = vkcs_networking_floatingip.bastion.address
  instance_id = vkcs_compute_instance.bastion.id
}