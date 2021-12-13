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
  environments = ["stage", "dev"]
  project_name = random_string.project_name.result
}

module "backend" {
  source  = "../../"
  backend_resource_group_name = "rg-terraform"
  environments = local.environments
  project_name = local.project_name
  resource_group_name = "rg-${local.project_name}" # -env is appended automatically
  identifier_uri_verified_domain = "blinqdev.wwan.no"
  role_assignment = "Owner"
}

output "key_vaults" {
  value = module.backend.key_vaults
}

output "service_principals" {
  value = module.backend.service_principals
  sensitive = true
}
