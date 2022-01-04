resource "azurerm_automation_account" "auto_account" {
  name                = "aa-${var.short}-${var.loc}-${terraform.workspace}-01"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  sku_name = "Basic"

  tags = local.tags
}

resource "azurerm_automation_runbook" "start_runbook" {
  name                = "Start-AzureVM"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  automation_account_name = azurerm_automation_account.auto_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is a start runbook"
  runbook_type            = "PowerShellWorkflow"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/craigthackerx/azure-challenge-solutions/mvp/azure-init/scripts/StartVMRunbook.ps1"
  }
}

resource "azurerm_automation_schedule" "start_vm" {
  name                    = "StartVM"
  resource_group_name     = azurerm_resource_group.vm_rg.name
  automation_account_name = azurerm_automation_account.auto_account.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"
  start_time              = "2022-01-03T20:00:00Z"
  description             = "Run every day"
}

resource "azurerm_automation_job_schedule" "start_vm_schedule" {
  resource_group_name     = azurerm_resource_group.vm_rg.name
  automation_account_name = azurerm_automation_account.auto_account.name
  schedule_name           = azurerm_automation_schedule.start_vm.name
  runbook_name            = azurerm_automation_runbook.start_runbook.name
  parameters = {
    azuresubscriptionid       = var.AZURE_SUBSCRIPTION_ID
  }
}