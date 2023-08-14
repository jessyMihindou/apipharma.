terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.68.0"
    }
  }
  required_version = ">= 0.14.9"
}
provider "azurerm" {
  skip_provider_registration = true

  features {}
}

