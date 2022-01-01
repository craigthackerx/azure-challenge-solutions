resource "azurerm_resource_group" "vm_rg" {
  location = "UK South"
  name     = "rg-${var.AZURE_SHORT}-${var.loc}-${terraform.workspace}-vm"
  tags     = local.tags
}

resource "azurerm_network_interface" "win_nic" {
  count               = var.win_count
  location            = "UK South"
  name                = "${local.win_vm_name}-nic"
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "${local.win_vm_name}-nic-ipconfig"
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  count                    = var.win_count
  location                 = azurerm_resource_group.vm_rg.location
  resource_group_name      = azurerm_resource_group.vm_rg.name
  name                     = local.win_vm_name
  admin_password           = data.azurerm_key_vault_secret.mgmt_local_admin_pwd.value
  admin_username           = "Local${var.AZURE_SHORT}Admin${terraform.workspace}"
  provision_vm_agent       = "true"
  enable_automatic_updates = "false"
  patch_mode               = "Manual"
  size                     = "Standard_B1s"

  network_interface_ids = [
    element(azurerm_network_interface.win_nic.*.id, count.index + 1)
  ]

  source_image_reference {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    name                 = "${local.win_vm_name}-osdisk"
    disk_size_gb         = "63"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_application_security_group" "win_asg" {
  name                = "asg-win${var.AZURE_SHORT}${var.loc}${terraform.workspace}"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  tags = local.tags
}

resource "azurerm_network_interface_application_security_group_association" "asgnicassoc" {
  count = var.win_count

  network_interface_id          = element(azurerm_network_interface.win_nic.*.id, count.index + 1)
  application_security_group_id = azurerm_application_security_group.win_asg.id
}

resource "azurerm_virtual_machine_extension" "win_custom_script" {
  count                = var.win_count
  name                 = "CustomScript"
  virtual_machine_id   = element(azurerm_windows_virtual_machine.win_vm.*.id, count.index + 1)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"


  protected_settings = <<PROTECTED_SETTINGS
      {
        "commandToExecute": "powershell -encodedCommand ${textencodebase64(file("../azure-init/scripts/WindowsInitScript.ps1"), "UTF-16LE")}"",
      }
  PROTECTED_SETTINGS

  tags = local.tags
}