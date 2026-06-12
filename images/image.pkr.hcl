packer {
  required_plugins {
    vkcs = {
      version = ">= 1.0.0"
      source = "github.com/hashicorp/openstack"
    }
  }
}

variable "image_name" {
  type = string
  default = "lab5-6"
}

source "vkcs" "ubuntu" {
  image_name = "lab5-6"
  flavor = "STD3-1-2"
  source_image_name = "ubuntu-24-202602051634.gite7a38aaf"
  ssh_username = "ubuntu"

  networks = ["8bedcd7e-4d2e-4b39-8b71-3848205480ce"]

  security_groups = ["default", "ssh+www"]

  volume_type = "ceph-ssd"
  volume_size = 10
  use_blockstorage_volume = true

  use_floating_ip = true
  floating_ip_network = "ec8c610e-6387-447e-83d2-d2c541e88164"
}

build {
  sources = ["source.vkcs.ubuntu"]
  
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nginx php-fpm",
      "sudo systemctl enable nginx",
      "sudo systemctl enable php8.3-fpm || sudo systemctl enable php-fpm || true",
      "sudo apt-get clean",
      "sudo rm -rf /var/lib/apt/lists/*",
    ]
  }
}