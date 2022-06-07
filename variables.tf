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
  description = "Specify the first day the SAS is active."
  default     = "2022-01-01"
}

variable "azurerm_storage_account_blob_container_sas_end_time" {
  type        = string
  description = "Specify the last day the SAS is active."
  default     = "2024-12-31"
}

variable "service_principal_password_end_date_relative_hours" {
  type        = string
  description = "Relative day from today that the service principal password expires."
  default     = "1440h"
}

variable "service_principal_password_rotating_days" {
  type        = number
  description = "Number in days the password for the service principal should rotate. When this number is reached, the password resource is destroyed and recreated. It requires Terraform to be run at all for any change to occur."
  default     = 30
}

