provider "azurerm" {
    features {}
}

module "azure-backend" {
  source  = "app.terraform.io/b24x7/terraform-backend/azurerm"
  version = "0.0.1-dev"
  backend_resource_group_name = "rg-terraform"
  environments = ["dev", "test", "prod"]
  project_name = "website"
}