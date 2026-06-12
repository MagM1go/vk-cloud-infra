terraform {
  backend "s3" {
    bucket    = "lab56eoooi"
    key       = "lab56/terraform.tfstate"
    endpoints = { s3 = "https://hb.ru-msk.vkcloud-storage.ru" }
    region    = "ru-msk"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    use_lockfile = true
  }
}