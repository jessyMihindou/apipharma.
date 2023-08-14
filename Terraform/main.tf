resource "azurerm_resource_group" "apipharma" {
  name     = "apipharma"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "apipharma" {
  name                = "apitweet-app-service-plan"
  location            = azurerm_resource_group.apipharma.location
  resource_group_name = azurerm_resource_group.apipharma.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "apipharma" {
  name                = "apipharma-app-service"
  location            = azurerm_resource_group.apipharma.location
  resource_group_name = azurerm_resource_group.apipharma.name
  app_service_plan_id = azurerm_app_service_plan.apipharma.id

  site_config {
    always_on       = true
    linux_fx_version = "DOCKER|gervaisjessy/apipharma:0.0.1"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}

output "app_service_url" {
  value = azurerm_app_service.apipharma.default_site_hostname
}



