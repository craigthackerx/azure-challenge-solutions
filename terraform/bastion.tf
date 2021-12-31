variable "azure_bastion_required_rules" {
  default = {
    "AllowHttpsInbound"                       = { priority = "120", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "TCP", source_address_prefix = "Internet", destination_address_prefix = "*" },
    "AllowGatewayManagerInbound"              = { priority = "130", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "TCP", source_address_prefix = "GatewayManager", destination_address_prefix = "*" },
    "AllowAzureLoadBalancerInbound"           = { priority = "140", direction = "Inbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "TCP", source_address_prefix = "AzureLoadBalancer", destination_address_prefix = "*" },
    "AllowBastionHostCommunication1"          = { priority = "150", direction = "Inbound", source_port = "*", destination_port = "5701", access = "Allow", protocol = "TCP", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowBastionHostCommunication2"          = { priority = "155", direction = "Inbound", source_port = "*", destination_port = "80", access = "Allow", protocol = "TCP", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowSSHRDPOutbound1"                    = { priority = "160", direction = "Outbound", source_port = "*", destination_port = "22", access = "Allow", protocol = "TCP", source_address_prefix = "*", destination_address_prefix = "VirtualNetwork" },
    "AllowSSHRDPOutbound2"                    = { priority = "165", direction = "Outbound", source_port = "*", destination_port = "3389", access = "Allow", protocol = "TCP", source_address_prefix = "*", destination_address_prefix = "VirtualNetwork" },
    "AllowAzureCloudOutbound2"                = { priority = "170", direction = "Outbound", source_port = "*", destination_port = "443", access = "Allow", protocol = "TCP", source_address_prefix = "*", destination_address_prefix = "AzureCloud" },
    "AllowAzureBastionCommunicationOutbound1" = { priority = "180", direction = "Outbound", source_port = "*", destination_port = "5701", access = "Allow", protocol = "TCP", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowAzureBastionCommunicationOutbound2" = { priority = "185", direction = "Outbound", source_port = "*", destination_port = "8080", access = "Allow", protocol = "TCP", source_address_prefix = "VirtualNetwork", destination_address_prefix = "VirtualNetwork" },
    "AllowGetSessionInformation"              = { priority = "190", direction = "Outbound", source_port = "*", destination_port = "80", access = "Allow", protocol = "TCP", source_address_prefix = "*", destination_address_prefix = "*" },

  }
}

resource "azurerm_public_ip" "bas_pip" {
  name                = "pip-${var.AZURE_SHORT}-${terraform.workspace}"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_bastion_host" "bas_host" {
  name                = "bas-${var.AZURE_SHORT}-${terraform.workspace}"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name

  ip_configuration {
    name                 = "bas-${var.AZURE_SHORT}-${terraform.workspace}-ipconfig"
    subnet_id            = azurerm_subnet.bastion_sn.name
    public_ip_address_id = azurerm_public_ip.bas_pip.id
  }

  tags = local.tags
}

resource "azurerm_network_security_group" "bas_nsg" {
  name                = "nsg-bas-${var.AZURE_SHORT}-${terraform.workspace}"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  tags                = local.tags
}

resource "azurerm_network_security_rule" "bas_nsg" {
  for_each = var.azure_bastion_required_rules

  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port
  destination_port_range      = each.value.destination_port
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.net_rg.name
  network_security_group_name = azurerm_network_security_group.bas_nsg.name
}

