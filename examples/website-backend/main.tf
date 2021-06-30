provider "azurerm" {
    features {}
}

module "azure-backend" {
  source = "../../"
  backend_resource_group_name = "rg-terraform"
  environments = ["dev", "test", "prod"]
  project_name = "website"
}