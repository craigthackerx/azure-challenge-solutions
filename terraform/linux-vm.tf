resource "azurerm_network_interface" "lnx_nic" {
  count               = var.lnx_count
  location            = azurerm_resource_group.vm_rg.location
  name                = "nic-lnx${var.short}${var.loc}${terraform.workspace}${count.index + 1}"
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "lnx${var.short}${var.loc}${terraform.workspace}${count.index + 1}-nic-ipconfig"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.main_sn.id
  }

  tags = local.tags
}

resource "azurerm_linux_virtual_machine" "lnx_vm" {
  count                           = var.lnx_count
  location                        = azurerm_resource_group.vm_rg.location
  resource_group_name             = azurerm_resource_group.vm_rg.name
  name                            = "lnx${var.short}${var.loc}${terraform.workspace}${count.index + 1}"
  computer_name                   = "lnx${var.short}${var.loc}${terraform.workspace}${count.index + 1}"
  admin_password                  = data.azurerm_key_vault_secret.mgmt_local_admin_pwd.value
  admin_username                  = "Local${var.short}Admin${terraform.workspace}"
  provision_vm_agent              = "true"
  size                            = "Standard_B1s"
  disable_password_authentication = true
  custom_data                     = base64encode(data.local_file.cloud_init.content)

  network_interface_ids = [
    element(azurerm_network_interface.lnx_nic.*.id, count.index + 1)
  ]

  admin_ssh_key {
    public_key = data.azurerm_ssh_public_key.mgmt_ssh_key.public_key
    username   = "Local${var.short}Admin${terraform.workspace}"
  }

  source_image_reference {
      publisher = "Oracle"
      offer     = "Oracle-Linux"
      sku       = "ol84-lvm-gen2"
      version   = "latest"
  }

  os_disk {
    name                 = "lnx${var.short}${var.loc}${terraform.workspace}${count.index + 1}-osdisk"
    disk_size_gb         = "63"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = local.tags
}

resource "azurerm_application_security_group" "lnx_asg" {
  name                = "asg-lnx${var.short}${var.loc}${terraform.workspace}"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  tags = local.tags
}

resource "azurerm_network_interface_application_security_group_association" "lnx_asg_association" {
  count = var.lnx_count

  network_interface_id          = element(azurerm_network_interface.lnx_nic.*.id, count.index + 1)
  application_security_group_id = azurerm_application_security_group.lnx_asg.id
}

# Need to use custom script instead of cloud-init - https://stackoverflow.com/questions/67741343/azure-cloud-init-failed-to-install-packages
resource "azurerm_virtual_machine_extension" "lnx_custom_script" {
  count                = var.lnx_count
  name                 = "CustomScript"
  virtual_machine_id   = element(azurerm_linux_virtual_machine.lnx_vm.*.id, count.index + 1)
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"

  protected_settings = <<PROTECTED_SETTINGS
      {
        "script": "${filebase64("../azure-init/scripts/linux-init.sh")}""
      }
PROTECTED_SETTINGS

  tags = local.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "stop_lnx_vm" {
  count              = var.win_count
  virtual_machine_id = element(azurerm_linux_virtual_machine.lnx_vm.*.id, count.index + 1)
  location           = azurerm_resource_group.vm_rg.location
  enabled            = true

  daily_recurrence_time = "2200"
  timezone              = "GMT Standard Time"

  notification_settings {
    enabled         = false

  }

  tags = local.tags
}
