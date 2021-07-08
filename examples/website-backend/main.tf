terraform {
  backend "azurerm" {}
}

provider "azurerm" {
    features {}
}


locals {
  environments = ["dev"]
  project_name = "kportal"
}

module "azure-backend" {
  source  = "../../"
  backend_resource_group_name = "rg-terraform"
  environments = local.environments
  project_name = local.project_name
  resource_group_name = "rg-${local.project_name}" # -env is appended automatically

  # enable_azuredevops = false
  # azuredevops = {
  #   project_name = "Kundeportal"
  #   project_description = "Managed by Terraform"
  #   visibility = "private"
  # }
}

module "service-principal-b24x7" {
  source  = "app.terraform.io/b24x7/service-principal/azuread"
  version = "1.0.0"

  for_each = toset(local.environments)
  name = "sp-tf-b24x7-${each.key}"
  # TODO: Add Role
  role = "Reader"
  scopes = [module.azure-backend.environment_resource_group[each.key].id]
}