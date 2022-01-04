resource "azurerm_network_security_group" "main_nsg" {
  name                = "nsg-${var.short}-${var.loc}-${terraform.workspace}-01"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "ALlowSSHRDPInboundFromBastion" {
  name                    = "ALlowSSHRDPInboundFromBastion"
  priority                = 120
  direction               = "Inbound"
  access                  = "Allow"
  protocol                = "TCP"
  source_port_range       = "*"
  destination_port_ranges = ["22", "3389"]
  source_address_prefixes = azurerm_subnet.bastion_sn.address_prefixes

  destination_application_security_group_ids = [
    azurerm_application_security_group.lnx_asg.id,
    azurerm_application_security_group.win_asg.id
  ]

  resource_group_name         = azurerm_resource_group.net_rg.name
  network_security_group_name = azurerm_network_security_group.main_nsg.name
}

resource "azurerm_network_security_rule" "AlllowWinToLnxInbound" {
  name                                       = "AllowWinToLnx"
  priority                                   = 200
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "TCP"
  source_port_range                          = "*"
  destination_port_ranges                    = ["22", "8080", "8090"]
  source_application_security_group_ids      = [azurerm_application_security_group.win_asg.id]
  destination_application_security_group_ids = [azurerm_application_security_group.lnx_asg.id]
  resource_group_name                        = azurerm_resource_group.net_rg.name
  network_security_group_name                = azurerm_network_security_group.main_nsg.name
}

#Explicit Deny Rule
resource "azurerm_network_security_rule" "DenyAllInbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_port_range      = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.net_rg.name
  network_security_group_name = azurerm_network_security_group.main_nsg.name
}

resource "azurerm_network_security_rule" "AllowInternetInboundToLnxAsg" {
  name                                       = "AllowInternetToLnxAsgInbound"
  priority                                   = 1200
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "TCP"
  source_port_range                          = "*"
  destination_port_ranges                    = ["8080"]
  source_address_prefix                      = "Internet"
  destination_application_security_group_ids = [azurerm_application_security_group.lnx_asg.id]
  resource_group_name                        = azurerm_resource_group.net_rg.name
  network_security_group_name                = azurerm_network_security_group.main_nsg.name
}

resource "azurerm_network_security_rule" "AlllowLBInboundToAsg" {
  name                                       = "AllowLBInboundToAsg"
  priority                                   = 1100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "TCP"
  source_port_range                          = "*"
  destination_port_ranges                    = ["8080"]
  source_address_prefix                      = "AzureLoadBalancer"
  destination_application_security_group_ids = [azurerm_application_security_group.lnx_asg.id]
  resource_group_name                        = azurerm_resource_group.net_rg.name
  network_security_group_name                = azurerm_network_security_group.main_nsg.name
}


resource "azurerm_subnet_network_security_group_association" "main_nsg_assoc" {
  network_security_group_id = azurerm_network_security_group.main_nsg.id
  subnet_id                 = azurerm_subnet.main_sn.id
}
