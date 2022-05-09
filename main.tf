terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.21.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
  }
}

# Get a reference to the backend resource group
data "azurerm_resource_group" "backend" {
  name = var.backend_resource_group_name
}

# Get a reference to the current Azure RM context to give it access to Key Vaults
data "azurerm_client_config" "current" {}

# Get a reference to the current subscription context to supply the Az DevOps integration
data "azurerm_subscription" "current" {}

# Create the resource groups where each environment will deploy resources to.
resource "azurerm_resource_group" "rg" {
  for_each = toset(var.environments)

  name     = "${var.resource_group_name}-${each.key}"
  location = var.location
  tags = {
    environment = "${each.key}"
  }
}

module "service-principal" {
  source                         = "../terraform-azuread-service-principal/"
  for_each                       = toset(var.environments)
  name                           = format("%s%s%s", "sp-tf-", "${var.project_name}-", each.key)
  role                           = var.role_assignment
  scopes                         = [azurerm_resource_group.rg[each.key].id]
  identifier_uri_verified_domain = var.identifier_uri_verified_domain
  app_name                       = format("%s-%s", var.project_name, each.key)
  password_rotating_hours        = var.service_principal_password_rotating_hours
  end_date_relative_hours        = var.service_principal_password_end_date_relative_hours

}

# The Key Vault where we will store all secrets that are outputs from this module
module "key-vault" {
  source              = "../terraform-azurerm-key-vault/"
  for_each            = toset(var.environments)
  name                = format("%s-%s-%s", "kv-tf", random_string.backend_id.result, each.key)
  resource_group_name = data.azurerm_resource_group.backend.name
  location            = data.azurerm_resource_group.backend.location
  access_policies = [
    {
      object_id               = module.service-principal[each.key].object_id
      secret_permissions      = ["Get", "List"]
      key_permissions         = []
      storage_permissions     = []
      certificate_permissions = []
    },
    {
      object_id               = data.azurerm_client_config.current.object_id
      secret_permissions      = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      key_permissions         = []
      storage_permissions     = []
      certificate_permissions = []
    }
  ]
}

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
  start             = local.storage_container_backend_sas_start
  expiry            = local.storage_container_backend_sas_end

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = true
  }
}
