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