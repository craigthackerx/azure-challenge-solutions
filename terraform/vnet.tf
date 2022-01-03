resource "azurerm_resource_group" "net_rg" {
  location = "UK South"
  name     = "rg-${var.short}-${var.loc}-${terraform.workspace}-net"
  tags     = local.tags
}

resource "azurerm_virtual_network" "main_vnet" {
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  name                = "vnet-${var.short}-${var.loc}-${terraform.workspace}-01"
  address_space       = ["10.0.0.0/23"]
  tags                = local.tags
}

resource "azurerm_subnet" "main_sn" {
  name                 = "sn-${azurerm_virtual_network.main_vnet.name}"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/26"]
}

resource "azurerm_subnet" "bastion_sn" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.net_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.1.224/27"]
}
