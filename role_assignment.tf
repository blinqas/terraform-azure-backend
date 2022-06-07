# Retrieve the data for the user specified role.
data "azurerm_role_definition" "main" {
  for_each = toset(var.environments)
  name     = var.role_assignment
}

# Assign user specified role(s) to the service principal.
resource "azurerm_role_assignment" "main" {
  for_each           = toset(var.environments)
  scope              = azurerm_resource_group.rg[each.key].id
  role_definition_id = format("%s%s", data.azurerm_subscription.current.id, data.azurerm_role_definition.main[each.key].id)
  principal_id       = module.service-principal[each.key].service_principal.object_id
}

