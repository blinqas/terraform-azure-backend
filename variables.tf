variable "backend_resource_group_name" {
  type = string
  description = "The name of the resource group that holds the backend resources"
}

variable "environments" {
  type = list(string)
  description = "List of environment names. Example: ['dev', 'stage', 'test', 'prod']"
}

variable "project_name" {
  type = string
  description = "The name of the project. All resources will be named accordingly. Example: kv-tf-project_name-environment"
}

variable "location" {
  type = string
  description = "The default Azure region to deploy resources to. Defaults to norwayeast"
  default = "norwayeast"
}

variable "enable_azuredevops" {
  description = "Set to true to enable Azure DevOps integration. This module creates a new Azure DevOps project which you configure in the variable azuredevops. Defaults to false."
  default = "false"
}

variable "azuredevops" {
  type = object({
    project_name = string
    project_description = string
    visibility = string
  })
  default = {
    project_name = ""
    project_description = "Managed by Terraform"
    visibility = "private"
  }
  description = "Configuration for Azure DevOps integration. If provided, a project will be created and all service principals will be connected as service connections."
}