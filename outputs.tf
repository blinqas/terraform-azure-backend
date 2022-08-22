output "environment_resource_group" {
  value       = azurerm_resource_group.rg
  description = "The resource group names of each environment"
}

output "key_vault" {
  value = azurerm_key_vault.backend
}

output "backend_id" {
  description = "Unique ID used to name resources in this module"
  value       = random_string.backend_id.result
}

output "service_principal" {
  value = module.service-principal
}

