# Create the resource groups where each environment will deploy resources to.
resource "azurerm_resource_group" "rg" {
  for_each = toset(var.environments)

  name     = "${var.resource_group_name}-${each.key}"
  location = var.location
  tags = {
    environment = "${each.key}"
  }
}

