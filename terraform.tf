terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.21.0, <3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.3.0, <4.0"
    }
  }
}

