output "environment_resource_group" {
  value       = azurerm_resource_group.rg
  description = "The resource group names of each environment"
}

# Should produce:
# { "dev" = { "name" = "x", "id" = "y" } }
output "key_vaults" {
  value = {
    for env in toset(var.environments) : 
      env => {
        "name" = module.key-vault[env].name,
        "id" = module.key-vault[env].id
      }
  }
}

output "backend_id" {
  description = "Unique ID used to name resources in this module"
  value = random_string.backend_id.result
}
