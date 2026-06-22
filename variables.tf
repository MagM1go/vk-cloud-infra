variable "username" {
  type = string
}

variable "cloud_password" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "region" {
  type    = string
  default = "RegionOne"
}

variable "availability_zone" {
  type    = string
  default = "MS1"
}

variable "public_cidr" {
  type = string
}

variable "private_cidr" {
  type = string
}

variable "external_network_id" {
  type = string
}

variable "keypair_name" {
  type    = string
  default = "vk-cloud-key"
}

variable "my_ip" {
  type = string
}

variable "web_flavor" {
  type    = string
  default = "STD3-1-2"
}

variable "bastion_flavor" {
  type    = string
  default = "STD3-1-2"
}

variable "monitoring_flavor" {
  type    = string
  default = "STD3-1-2"
}

variable "db_flavor_id" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "tg_bot_token" {
  type      = string
  sensitive = true
}

variable "tg_chat_id" {
  type      = string
  sensitive = true
}
