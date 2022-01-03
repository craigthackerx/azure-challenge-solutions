$runBookSplat = @{
    Name                  = 'Azure-VM-Schedule-Start'
    ResourceGroupName     = 'rg-hw-uks-mvp-vm'
    AutomationAccountName = 'aa-hw-uks-mvp-01'
    Path                  = 'https://raw.githubusercontent.com/craigthackerx/azure-challenge-solutions/mvp/azure-init/scripts/StartVMs.ps1'
    Type                  = 'PowerShell'
    Force                 = $true
}
Import-AzAutomationRunbook @runBookSplat