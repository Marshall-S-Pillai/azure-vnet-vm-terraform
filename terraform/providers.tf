provider "azurerm" {
  features {}

  use_oidc = var.use_oidc

  subscription_id = var.subscription_id != "" ? var.subscription_id : null
}
