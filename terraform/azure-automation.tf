resource "azurerm_automation_account" "auto_account" {
  name                = "aa-${var.short}-${var.loc}-${terraform.workspace}-01"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  sku_name = "Basic"

  tags = local.tags
}
#For this solution to work, you need to manually create a RunAsAccount in the portal - It is currently not possible to do this in Terraform and its very quick.  This is done via Automation Account -> Run As Accounts -> Create Run As Account.  Done :)
resource "azurerm_automation_runbook" "start_runbook" {
  name                = "Start-AzureVM"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name
  automation_account_name = azurerm_automation_account.auto_account.name
  log_verbose             = "true"
  log_progress            = "true"
  description             = "This is a start PowerShell script, which, dependant on schedule, will start all VMs in a given subscription."
  runbook_type            = "PowerShell"

  publish_content_link {
    uri = "https://raw.githubusercontent.com/craigthackerx/azure-challenge-solutions/mvp/azure-init/scripts/StartVMs.ps1"
  }

  tags = local.tags
}

resource "azurerm_automation_schedule" "start_vm" {
  name                    = "StartVM"
  resource_group_name     = azurerm_resource_group.vm_rg.name
  automation_account_name = azurerm_automation_account.auto_account.name
  frequency               = "Day"
  interval                = 1
  timezone                = "Europe/London"
  start_time              = "2022-01-05T08:00:00Z"
  description             = "Run every day at 8am"
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