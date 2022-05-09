locals {
  storage_container_backend_sas_start = var.storage_account_blob_container_sas_start_time == "" ? timestamp() : var.storage_account_blob_container_sas_start_time
  storage_container_backend_sas_end   = timeadd(local.storage_container_backend_sas_start, var.storage_account_blob_container_sas_end_time)
}

