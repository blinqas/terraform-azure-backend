# Reference to the backend resource group
data "azurerm_resource_group" "backend" {
  name = var.backend_resource_group_name
}

# Reference to the current Azure RM context 
data "azurerm_client_config" "current" {}

# Reference to the current subscription context 
data "azurerm_subscription" "current" {}

