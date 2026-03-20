provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "palja-rg"
  location = "Korea Central"
}
