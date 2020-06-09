resource "azurerm_resource_group" "demo" {
  name = "demo"
  location = "France Central"
}

resource "azurerm_availability_set" "demo" {
  name                = "demo"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  platform_fault_domain_count  = 2
  platform_update_domain_count = 5

  managed = true
}

resource "azurerm_storage_account" "demo" {
  name                      = "myargodemostorageaccount"
  resource_group_name       = azurerm_resource_group.demo.name
  location                  = "francecentral"
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "demo-test" {
  name                  = "test"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "private"
  depends_on = [azurerm_storage_account.demo]
}

resource "cloudflare_record" "cloudflare-dns-demo" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "demo"
  value   = "xxx.xxx.xxx.xxx"
  type    = "A"
  proxied = true
}

resource "pingdom_check" "pingdom-check-demo" {
    type = "http"
    name = "demo"
    host = "demo.mycompany.com"
    paused = true
    probefilters = "region:EU"
    resolution = 1
    sendnotificationwhendown = 4
    url = "/health"
    encryption = true
    notifyagainevery = 2
    notifywhenbackup = true
    lifecycle {
      ignore_changes = [
        paused,
        integrationids
      ]
    }
}
