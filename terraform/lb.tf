resource "azurerm_public_ip" "lb_pip" {
  name                = "pip-lb-${var.short}-${var.loc}-${terraform.workspace}"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
  tags                = local.tags
}

resource "azurerm_lb" "lb_public" {
  name                = "lb-${var.short}-${var.loc}-${terraform.workspace}"
  location            = azurerm_resource_group.net_rg.location
  resource_group_name = azurerm_resource_group.net_rg.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "lb-${var.short}-${var.loc}-${terraform.workspace}-ipconfig"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
    public_ip_prefix_id  = azurerm_public_ip.lb_pip.public_ip_prefix_id
  }

  tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "lb_address_pool" {

  loadbalancer_id = azurerm_lb.lb_public.id
  name            = "pool-lnx-${var.short}-${var.loc}-${terraform.workspace}"

}

resource "azurerm_lb_probe" "lb_app_probe" {

  resource_group_name = azurerm_resource_group.net_rg.name

  loadbalancer_id     = azurerm_lb.lb_public.id
  name                = "app-probe"
  protocol            = "Tcp"
  port                = 8080
  interval_in_seconds = "5"
  number_of_probes    = "2"
}


resource "azurerm_lb_rule" "lb_app_rule" {

  resource_group_name = azurerm_resource_group.net_rg.name

  frontend_port = azurerm_lb_probe.lb_app_probe.port
  backend_port  = azurerm_lb_probe.lb_app_probe.port

  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_address_pool.id]
  probe_id                = azurerm_lb_probe.lb_app_probe.id

  frontend_ip_configuration_name = azurerm_lb.lb_public.frontend_ip_configuration.0.name
  loadbalancer_id                = azurerm_lb.lb_public.id

  name                    = "rule-app-${var.short}-${var.loc}-${terraform.workspace}"
  enable_floating_ip      = false
  enable_tcp_reset        = false
  idle_timeout_in_minutes = "4"


  protocol = azurerm_lb_probe.lb_app_probe.protocol
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_pool_association" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address_pool.id
  ip_configuration_name   = element(azurerm_network_interface.lnx_nic.*.ip_configuration.0.name, 0)
  network_interface_id    = element(azurerm_network_interface.lnx_nic.*.id, 0)
}