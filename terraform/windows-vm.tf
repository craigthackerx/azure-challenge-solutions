resource "azurerm_resource_group" "vm_rg" {
  location = "UK South"
  name     = "rg-${var.AZURE_SHORT}-${terraform.workspace}-vm"
  tags     = local.tags
}