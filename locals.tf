locals {
  storage_container_backend_sas_start = var.azurerm_storage_account_blob_container_sas_start_time == "" ? timestamp() : var.azurerm_storage_account_blob_container_sas_start_time
  storage_container_backend_sas_end   = var.azurerm_storage_account_blob_container_sas_end_time == "" ? timeadd(local.storage_container_backend_sas_start, "720h") : var.azurerm_storage_account_blob_container_sas_end_time
}

