# This is what needs to be done to make sure the migration is successful
terraform {
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

locals {
  environments = ["stage", "prod"]
  project_name = "v4mig"
}

# A major drawback with the module is we cannot automate Application Permissions. Manually assign the service principal delegated permissions: Group.Read.All, User.Read, Application.Read.All
# 
module "terraform-backend" {
  source = "../terraform-azurerm-terraform-backend/"
  #version                        = "3.2.0"
  backend_resource_group_name    = "rg-terraform-backend"
  environments                   = local.environments
  project_name                   = local.project_name
  resource_group_name            = "CCB_${local.project_name}_TF" # -Environment automatically appended
  identifier_uri_verified_domain = "blinQVestLab.onmicrosoft.com"
  role_assignment                = "Owner"
}

data "azurerm_subscription" "current" {}

# Reference to the actual Service Principal
data "azuread_service_principal" "sp" {
  #application_id = module.terraform-backend.service_principals[0]["stage"].client_id
  for_each       = toset(local.environments)
  application_id = module.terraform-backend.service_principal[each.key].application.application_id
}

# Key Vault stuff
moved {
  from = module.terraform-backend.module.key-vault["stage"].azurerm_key_vault.kv
  to   = module.terraform-backend.azurerm_key_vault.backend["stage"]
}

moved {
  from = module.terraform-backend.module.key-vault["prod"].azurerm_key_vault.kv
  to   = module.terraform-backend.azurerm_key_vault.backend["prod"]
}

moved {
  from = module.terraform-backend.module.key-vault["stage"].azurerm_key_vault_access_policy.ap[0]
  to   = module.terraform-backend.azurerm_key_vault_access_policy.service_principal["stage"]
}

moved {
  from = module.terraform-backend.module.key-vault["stage"].azurerm_key_vault_access_policy.ap[1]
  to   = module.terraform-backend.azurerm_key_vault_access_policy.engineer["stage"]
}

moved {
  from = module.terraform-backend.module.key-vault["prod"].azurerm_key_vault_access_policy.ap[0]
  to   = module.terraform-backend.azurerm_key_vault_access_policy.service_principal["prod"]
}

moved {
  from = module.terraform-backend.module.key-vault["prod"].azurerm_key_vault_access_policy.ap[1]
  to   = module.terraform-backend.azurerm_key_vault_access_policy.engineer["prod"]
}

# Role assignment stuff
moved {
  from = module.terraform-backend.module.service-principal["stage"].azurerm_role_assignment.main[0]
  to   = module.terraform-backend.azurerm_role_assignment.main["stage"]
}

moved {
  from = module.terraform-backend.module.service-principal["prod"].azurerm_role_assignment.main[0]
  to   = module.terraform-backend.azurerm_role_assignment.main["prod"]
}

