variable "network_id" { type = string }
variable "bastion_sg_id" { type = string }
variable "db_sg_id" { type = string }
variable "lb_sg_id" { type = string }
variable "project_name" { type = string }
variable "availability_zone" { type = string }
variable "db_flavor_id" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "web_sg_name" { type = string }
variable "web_sg_id" { type = string }
variable "bastion_sg_name" { type = string }
variable "monitoring_sg_name" { type = string }
variable "monitoring_sg_id" { type = string }
variable "public_subnet_id" { type = string }
variable "private_subnet_id" { type = string }
variable "external_network_name" { type = string }
variable "external_network_id" { type = string }
variable "monitoring_flavor" { type = string }
variable "bastion_flavor" { type = string }
variable "web_flavor" { type = string }

variable "keypair_name" { type = string }

variable "tg_bot_token" {
  type      = string
  sensitive = true
}

variable "tg_chat_id" {
  type      = string
  sensitive = true
}
