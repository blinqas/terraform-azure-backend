# Create the Storage Account that will hold each environments Storage Container, where the state files will
# be stored
resource "azurerm_storage_account" "sa" {
  name                     = lower(format("%s%s%s", "satf", var.project_name, random_string.backend_id.result))
  resource_group_name      = data.azurerm_resource_group.backend.name
  location                 = data.azurerm_resource_group.backend.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

