resource "azurerm_key_vault_secret" "client_secret" {
  for_each     = toset(var.environments)
  key_vault_id = module.key-vault[each.key].id
  name         = "kv-arm-client-secret-${each.key}"
  value        = module.service-principal[each.key].client_secret
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "client_id" {
  for_each     = toset(var.environments)
  key_vault_id = module.key-vault[each.key].id
  name         = "kv-arm-client-id-${each.key}"
  value        = module.service-principal[each.key].client_id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "tenant_id" {
  for_each     = toset(var.environments)
  key_vault_id = module.key-vault[each.key].id
  name         = "kv-arm-tenant-id-${each.key}"
  value        = module.service-principal[each.key].tenant_id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "subscription_id" {
  for_each     = toset(var.environments)
  key_vault_id = module.key-vault[each.key].id
  name         = "kv-arm-subscription-id-${each.key}"
  value        = module.service-principal[each.key].subscription_id
  tags = {
    environment = each.key
  }
}

# Store each SAS token in each environments respective Key Vault
resource "azurerm_key_vault_secret" "sas" {
  for_each     = toset(var.environments)
  name         = "kv-sc-sas-${each.key}"
  value        = data.azurerm_storage_account_blob_container_sas.infrastructure[each.key].sas
  key_vault_id = module.key-vault[each.key].id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "arm_rg_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-rg-name-${each.key}"
  value        = var.backend_resource_group_name
  key_vault_id = module.key-vault[each.key].id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "arm_sa_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-sa-name-${each.key}"
  value        = azurerm_storage_account.sa.name
  key_vault_id = module.key-vault[each.key].id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "arm_sc_name" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-sc-name-${each.key}"
  value        = azurerm_storage_container.sc[each.key].name
  key_vault_id = module.key-vault[each.key].id
  tags = {
    environment = each.key
  }
}

resource "azurerm_key_vault_secret" "arm_state_key" {
  for_each     = toset(var.environments)
  name         = "kv-arm-state-key-${each.key}"
  value        = "${each.key}.tfstate"
  key_vault_id = module.key-vault[each.key].id
  tags = {
    environment = each.key
  }
}
