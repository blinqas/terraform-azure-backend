# Create the Storage Container that will hold the state for each environment
resource "azurerm_storage_container" "sc" {
  for_each             = toset(var.environments)
  name                 = "sc-tf-${each.key}"
  storage_account_name = azurerm_storage_account.sa.name
}

# Get a reference to the SAS token for each environment's storage container
data "azurerm_storage_account_blob_container_sas" "infrastructure" {
  for_each       = azurerm_storage_container.sc
  container_name = each.value.name

  connection_string = azurerm_storage_account.sa.primary_connection_string
  start             = var.storage_account_blob_container_sas_start_time
  expiry            = var.storage_account_blob_container_sas_end_time

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = true
  }
}

