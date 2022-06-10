terraform {
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

locals {
  environments = ["test"]
  project_name = "sastest"
}

module "terraform-backend" {
  source                         = "../../../terraform-azurerm-terraform-backend/"
  backend_resource_group_name    = "rg-terraform-backend"
  environments                   = local.environments
  project_name                   = local.project_name
  resource_group_name            = "rg-${local.project_name}-tf"
  identifier_uri_verified_domain = "blinqdev.onmicrosoft.com"
  role_assignment                = "Contributor"
}

