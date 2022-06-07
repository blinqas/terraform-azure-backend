provider "azurerm" {
  features {}
}

locals {
  environments = ["dev"]
  project_name = "v4test"
}

module "backend" {
  source                         = "../../"
  backend_resource_group_name    = "rg-terraform-backend"
  environments                   = local.environments
  project_name                   = local.project_name
  resource_group_name            = "rg-${local.project_name}" # -env is appended automatically
  identifier_uri_verified_domain = "blinQVestLab.onmicrosoft.com"
}

