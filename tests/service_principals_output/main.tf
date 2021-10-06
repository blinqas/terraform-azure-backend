terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
}

resource "random_string" "project_name" {
  length = 4
  lower = true
  special = false
}

locals {
  environments = ["dev", "feature"]
  project_name = random_string.project_name.result
}

module "azure-backend" {
  source  = "../../"
  backend_resource_group_name = "rg-terraform"
  environments = local.environments
  project_name = local.project_name
  project_name_short = "kk"
  resource_group_name = "rg-${local.project_name}" # -env is appended automatically
}

output "key_vaults" {
  value = module.azure-backend.key_vaults
}

