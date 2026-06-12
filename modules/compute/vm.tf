data "vkcs_images_image" "golden" {
  name        = "lab5-6"
  most_recent = true
}

data "vkcs_images_image" "ubuntu" {
  name        = "ubuntu-24-202602051634.gite7a38aaf"
  most_recent = true
}

data "vkcs_compute_flavor" "web" {
  name = var.web_flavor
}

data "vkcs_compute_flavor" "bastion" {
  name = var.bastion_flavor
}

data "vkcs_compute_flavor" "monitoring" {
  name = var.monitoring_flavor
}