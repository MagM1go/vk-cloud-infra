variable "project_name" {
  type = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "external_network_id" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "MS1"
}

variable "k8s_version" {
  type    = string
  default = "v1.34.2"
}

variable "master_flavor" {
  type    = string
  default = "STD3-1-2"
}

variable "worker_flavor" {
  type    = string
  default = "STD3-1-2"
}
