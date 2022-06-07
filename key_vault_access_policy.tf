# Create a access policy for the current engineer. TODO: Replace object_id with a group_id.
resource "azurerm_key_vault_access_policy" "engineer" {
  for_each           = toset(var.environments)
  key_vault_id       = azurerm_key_vault.backend[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
  depends_on         = [azurerm_key_vault.backend]
}

# Create a access policy for the service principals.
resource "azurerm_key_vault_access_policy" "service_principal" {
  for_each           = toset(var.environments)
  key_vault_id       = azurerm_key_vault.backend[each.key].id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = module.service-principal[each.key].service_principal.object_id
  secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
}

