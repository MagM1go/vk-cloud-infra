module "security" {
  source = "./modules/security"

  my_ip        = var.my_ip
  project_name = var.project_name
}

module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  public_cidr         = var.public_cidr
  private_cidr        = var.private_cidr
  external_network_id = var.external_network_id
}

module "compute" {
  source = "./modules/compute"

  # database
  project_name      = var.project_name
  db_sg_id          = module.security.db_sg_id
  network_id        = module.network.network_id
  availability_zone = var.availability_zone
  db_flavor_id      = var.db_flavor_id
  db_password       = var.db_password

  # VM
  web_sg_name           = module.security.web_sg_name
  bastion_sg_name       = module.security.bastion_sg_name
  monitoring_sg_name    = module.security.monitoring_sg_name
  lb_sg_id              = module.security.lb_sg_id
  public_subnet_id      = module.network.public_subnet_id
  private_subnet_id     = module.network.private_subnet_id
  external_network_name = module.network.external_network_name
  external_network_id   = var.external_network_id
  web_flavor            = var.web_flavor
  bastion_flavor        = var.bastion_flavor
  monitoring_flavor     = var.monitoring_flavor

  # SSH ключ и Telegram для cloud-init
  keypair_name = var.keypair_name
  tg_bot_token = var.tg_bot_token
  tg_chat_id   = var.tg_chat_id
}

module "k8s" {
  source = "./modules/k8s"

  project_name        = var.project_name
  network_id          = module.network.network_id
  subnet_id           = module.network.private_subnet_id
  external_network_id = var.external_network_id
}