variable "backend_resource_group_name" {
  type        = string
  description = "The name of the resource group that holds the backend resources"
}

variable "environments" {
  type        = list(string)
  description = "List of environment names. Example: ['dev', 'stage', 'test', 'prod']"
}

variable "project_name" {
  type        = string
  description = "The name of the project. All resources will be named accordingly. Example: kv-tf-project_name-environment"
}

variable "location" {
  type        = string
  description = "The default Azure region to deploy resources to. Defaults to norwayeast"
  default     = "norwayeast"
}

variable "resource_group_name" {
  type        = string
  description = "Name of resource group that are created per environment. The current environment name is always appended like -env. Example: rg-example-dev"
}

variable "identifier_uri_verified_domain" {
  type        = string
  description = " Change since October 2021 requires a verified domain of the organization or its subdomain. Example: yourdomain.com"
}

variable "role_assignment" {
  type        = string
  description = "Specify a built-in Azure AD role which the service principal per environment will be assigned on their respective resource group."
  default     = "Contributor"
}

variable "azurerm_storage_account_blob_container_sas_start_time" {
  type        = string
  description = "Specify the first day the SAS is active. If left empty, start time is automatically calculated from timestamp(), meaning it is updated everytime this module runs."
  default     = ""
}

variable "azurerm_storage_account_blob_container_sas_end_time" {
  type        = string
  description = "Specify the last day the SAS is active."
  default     = ""
}

