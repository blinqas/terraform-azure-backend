terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "1.6.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.65.0"
    }
  }
}

# Get a reference to the backend resource group
data "azurerm_resource_group" "backend" {
  name = var.backend_resource_group_name
}

# Get a reference to the current Azure RM context to give it access to Key Vaults
data "azurerm_client_config" "current" {}

# Create the resource groups where each environment will deploy resources to.
resource "azurerm_resource_group" "rg" {
  count = length(var.environments)

  name     = format("%s%s%s", "rg-", "${var.project_name}-", var.environments[count.index])
  location = var.location
  tags = {
    environment = "${var.environments[count.index]}"
  }
}

module "service-principal" {
  #source  = "app.terraform.io/b24x7/service-principal/azuread"
  source = "../terraform-azuread-service-principal"
  #version = "1.0.0"
  count   = length(var.environments)

  name   = format("%s%s%s", "sp-tf-", "${var.project_name}-", var.environments[count.index])
  role   = "Contributor"
  scopes = [azurerm_resource_group.rg[count.index].id]
}

# The Key Vault where we will store all secrets that are outputs from this module
module "key-vault" {
  #source              = "app.terraform.io/b24x7/key-vault/azurerm"
  #version             = "1.0.0"
  source = "../terraform-azurerm-key-vault"
  count               = length(var.environments)
  name                = format("%s%s%s", "kvtf", "${var.project_name}pipeline-", var.environments[count.index])
  resource_group_name = data.azurerm_resource_group.backend.name
  location            = data.azurerm_resource_group.backend.location

  access_policies = [
    {
      object_id               = module.service-principal[count.index].object_id
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
  name                = format("%s%s%s", "sa", var.project_name, random_integer.sa.result)
  resource_group_name = data.azurerm_resource_group.backend.name
  location            = data.azurerm_resource_group.backend.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

# Create a random integer that will be used to create a unique  name for the Storage Account
resource "random_integer" "sa" {
  min = 1000
  max = 9000
}

# Create the Storage Container that will hold the state for each environment
resource "azurerm_storage_container" "sc" {
  count                = length(var.environments)
  name                 = var.environments[count.index]
  storage_account_name = azurerm_storage_account.sa.name
}

# Get a reference to the SAS token for each environment's storage container
data "azurerm_storage_account_blob_container_sas" "infrastructure" {
  count             = length(var.environments)
  connection_string = azurerm_storage_account.sa.primary_connection_string

  container_name = azurerm_storage_container.sc[count.index].name
  start          = "2021-06-30"
  expiry         = "2022-06-30"

  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = true
  }
}
