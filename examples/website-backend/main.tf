terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
}

module "azure-backend" {
  source  = "../../"
  backend_resource_group_name = "rg-terraform"
  environments = ["dev"]
  project_name = "kportal"

  # enable_azuredevops = false
  # azuredevops = {
  #   project_name = "Kundeportal"
  #   project_description = "Managed by Terraform"
  #   visibility = "private"
  # }
}