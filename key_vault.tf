# The Key Vault where we will store all secrets that are outputs from this module
resource "azurerm_key_vault" "backend" {
  for_each                   = toset(var.environments)
  name                       = format("%s-%s-%s", "kv-tf", random_string.backend_id.result, each.key)
  resource_group_name        = data.azurerm_resource_group.backend.name
  location                   = data.azurerm_resource_group.backend.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  sku_name                   = "standard"
}

