# AWS S3에 Azure tfstate 저장 (tfstate 금고를 AWS로 통일)
terraform {
  backend "s3" {
    bucket         = "palja-terraform-backend"
    key            = "azure/terraform.tfstate"
    region         = "ap-northeast-2"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group 생성
resource "azurerm_resource_group" "rg" {
  name     = "palja-rg"
  location = var.region
}