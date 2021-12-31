data "azurerm_resource_group" "mgmt_rg" {
  name = "rg-${var.AZURE_SHORT}-${var.loc}-${terraform.workspace}-mgt"
}

data "azurerm_ssh_public_key" "mgmt_ssh_key" {
  name                = "ssh-${var.AZURE_SHORT}-${var.loc}-${terraform.workspace}-pub-mgt"
  resource_group_name = data.azurerm_resource_group.mgmt_rg.name
}

data "azurerm_key_vault" "mgmt_kv" {
  name                = "kv-${var.AZURE_SHORT}-${var.loc}-${terraform.workspace}-mgt-01"
  resource_group_name = data.azurerm_resource_group.mgmt_rg.name
}

data "azurerm_key_vault_secret" "mgmt_local_admin_pwd" {
  key_vault_id = data.azurerm_key_vault.mgmt_kv.id
  name         = "Local${var.AZURE_SHORT}Admin${terraform.workspace}-pwd"

}