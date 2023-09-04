resource "azurerm_linux_web_app" "this" {
  name                = format("app-%s", local.resource_suffix_kebabcase)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_service_plan.this.location
  service_plan_id     = azurerm_service_plan.this.id
  tags                = local.tags

  https_only = true

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    AZURE_COSMOS_CONNECTION_STRING  = azurerm_cosmosdb_account.this.connection_strings[0]
    AZURE_COSMOS_DATABASE           = "catalogdb"
    AZURE_REDIS_CONNECTION_STRING   = azurerm_redis_cache.this.primary_connection_string
    PRODUCT_LIST_CACHE_DISABLE      = "0"
    SIMULATED_DB_LATENCY_IN_SECONDS = "0"
  }

  site_config {
    application_stack {
      dotnet_version = "7.0"
    }
  }
}
