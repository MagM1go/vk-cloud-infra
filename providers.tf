terraform {
  required_providers {
    vkcs = {
      source  = "vk-cs/vkcs"
      version = "~> 0.15"
    }
  }
}

provider "vkcs" {
  auth_url         = "https://msk.cloud.vk.com/infra/identity/v3/"
  user_domain_name = "users"
  region           = var.region
  username         = var.username
  password         = var.cloud_password
  project_id       = var.project_id
}
