output "environment_resource_group" {
  value       = azurerm_resource_group.rg
  description = "The resource group names of each environment"
}

# Should produce:
# { "dev" = { "name" = "x", "id" = "y" } }
output "key_vaults" {
  value = azurerm_key_vault.backend[*]
}

output "backend_id" {
  description = "Unique ID used to name resources in this module"
  value       = random_string.backend_id.result
}

output "service_principal" {
  value = module.service-principal
}

