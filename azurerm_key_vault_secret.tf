resource "azurerm_key_vault_secret" "client_secret" {
  count = length(module.service-principal)
  key_vault_id = module.key-vault[count.index].id
  name = "kv-arm-client-secret"
  value = module.service-principal[count.index].client_secret
  tags = {
    environment = var.environments[count.index]
  }
}

resource "azurerm_key_vault_secret" "client_id" {
  count = length(module.service-principal)
  key_vault_id = module.key-vault[count.index].id
  name = "kv-arm-client-id"
  value = module.service-principal[count.index].client_id
  tags = {
    environment = var.environments[count.index]
  }
}

resource "azurerm_key_vault_secret" "tenant_id" {
  count = length(module.service-principal)
  key_vault_id = module.key-vault[count.index].id
  name = "kv-arm-tenant-id"
  value = module.service-principal[count.index].tenant_id
  tags = {
    environment = var.environments[count.index]
  }
}

resource "azurerm_key_vault_secret" "subscription_id" {
  count = length(module.service-principal)
  key_vault_id = module.key-vault[count.index].id
  name = "kv-arm-subscription-id"
  value = module.service-principal[count.index].subscription_id
  tags = {
    environment = var.environments[count.index]
  }
}

# Store each SAS token in each environments respective Key Vault
resource "azurerm_key_vault_secret" "sas" {
  count        = length(var.environments)
  name         = format("%s%s", "kv-sc-sas-", var.environments[count.index])
  value        = data.azurerm_storage_account_blob_container_sas.infrastructure[count.index].sas
  key_vault_id = module.key-vault[count.index].id
}