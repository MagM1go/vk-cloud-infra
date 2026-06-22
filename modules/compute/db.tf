resource "vkcs_db_instance" "postgres" {
  name              = "${var.project_name}-postgres"
  flavor_id         = var.db_flavor_id
  availability_zone = var.availability_zone

  datastore {
    type    = "postgresql"
    version = "16"
  }

  size        = 10
  volume_type = "ceph-ssd"

  network {
    uuid            = var.network_id
    security_groups = [var.db_sg_id]
    subnet_id       = var.private_subnet_id
  }

  root_enabled  = true
  root_password = var.db_password
}

resource "vkcs_db_database" "webapp" {
  name    = "webapp_db"
  dbms_id = vkcs_db_instance.postgres.id
  charset = "utf8"
}

resource "vkcs_db_user" "webapp" {
  name      = "webapp"
  password  = var.db_password
  dbms_id   = vkcs_db_instance.postgres.id
  databases = [vkcs_db_database.webapp.name]
}