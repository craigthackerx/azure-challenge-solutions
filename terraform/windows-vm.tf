resource "azurerm_resource_group" "vm_rg" {
  location = "UK South"
  name     = "rg-${var.AZURE_SHORT}-${var.loc}-${terraform.workspace}-vm"
  tags     = local.tags
}