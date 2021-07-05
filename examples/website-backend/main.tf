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
  environments = ["dev"]
  project_name = "kportal"

  enable_azuredevops = true
  azuredevops = {
    project_name = "Kundeportal"
    project_description = "Managed by Terraform"
    visibility = "private"
  }
}