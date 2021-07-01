terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
}

module "azure-backend" {
  source  = "../../"
  #version = "0.0.1-dev"
  backend_resource_group_name = "rg-terraform"
  environments = ["dev", "test", "prod"]
  project_name = "kportal"
}