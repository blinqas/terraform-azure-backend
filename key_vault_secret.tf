resource "azurerm_key_vault_secret" "client_secret" {
  for_each     = toset(var.environments)
  key_vault_id = azurerm_key_vault.backend[each.key].id
  name         = "kv-arm-client-secret"
  value        = module.service-principal[each.key].service_principal_password
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "client_id" {
  for_each     = toset(var.environments)
  key_vault_id = azurerm_key_vault.backend[each.key].id
  name         = "kv-arm-client-id"
  value        = module.service-principal[each.key].service_principal.id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "tenant_id" {
  for_each     = toset(var.environments)
  key_vault_id = azurerm_key_vault.backend[each.key].id
  name         = "kv-arm-tenant-id"
  value        = data.azurerm_client_config.current.tenant_id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "subscription_id" {
  for_each     = toset(var.environments)
  key_vault_id = azurerm_key_vault.backend[each.key].id
  name         = "kv-arm-subscription-id"
  value        = data.azurerm_subscription.current.subscription_id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

# Store each SAS token in each environments respective Key Vault
resource "azurerm_key_vault_secret" "sas" {
  for_each     = toset(var.environments)
  name         = "kv-sc-sas"
  value        = data.azurerm_storage_account_blob_container_sas.infrastructure[each.key].sas
  key_vault_id = azurerm_key_vault.backend[each.key].id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "arm_rg_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-rg-name"
  value        = var.backend_resource_group_name
  key_vault_id = azurerm_key_vault.backend[each.key].id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "arm_sa_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-sa-name"
  value        = azurerm_storage_account.sa.name
  key_vault_id = azurerm_key_vault.backend[each.key].id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "arm_sc_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-sc-name"
  value        = azurerm_storage_container.sc[each.key].name
  key_vault_id = azurerm_key_vault.backend[each.key].id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

resource "azurerm_key_vault_secret" "arm_state_key" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-key"
  value        = "${each.key}.tfstate"
  key_vault_id = azurerm_key_vault.backend[each.key].id
  tags = {
    environment = each.key
  }
  depends_on = [azurerm_key_vault_access_policy.engineer]
}

