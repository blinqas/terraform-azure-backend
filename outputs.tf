output "environment_resource_group" {
  value       = azurerm_resource_group.rg
  description = "The resource group names of each environment"
}

output "key_vaults" {
  value = module.key-vault
}

output "backend_id" {
  description = "Unique ID used to name resources in this module"
  value       = random_string.backend_id.result
}

output "service_principals" {
  value = module.service-principal
}

output "sas" {
  description = "SAS generated for the storage container which holds Terraform state."
  value       = data.azurerm_storage_account_blob_container_sas.infrastructure
  sensitive   = true
}

