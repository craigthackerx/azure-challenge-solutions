## Get the Azure Automation Acount Information
$azConn = Get-AutomationConnection -Name 'AzureRunAsConnection'

## Add the automation account context to the session
Add-AzureRMAccount -ServicePrincipal -Tenant $azConn.TenantID -ApplicationId $azConn.ApplicationId -CertificateThumbprint $azConn.CertificateThumbprint

## Get the Azure VMs
$azVMs = Get-AzureRMVM

## Start the VMs
$azVMs | Start-AzureRMVM