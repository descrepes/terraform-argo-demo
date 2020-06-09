variable "pingdom_user" {}
variable "pingdom_password" {}
variable "pingdom_api_key" {}
variable "cloudflare_zone_id" {}

provider "azurerm" {
  version = "=2.8.0"

  features {}
}

provider "k8s" {
  load_config_file = "false"
}

provider "cloudflare" {
  version = "=2.6.0"
}

provider "vault" {
}

provider "pingdom" {
    user = "${var.pingdom_user}"
    password = "${var.pingdom_password}"
    api_key = "${var.pingdom_api_key}"
}

terraform {
  backend "azurerm" {
    storage_account_name = "demo"
    container_name       = "tfstate"
    key                  = "demo.terraform.tfstate"
  }
}
