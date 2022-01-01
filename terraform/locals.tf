locals {
  win_vm_name = "vm{var.AZURE_SHORT}${var.loc}${terraform.workspace}${count.index}"
  lnx_vm_name = "vm{var.AZURE_SHORT}${var.loc}${terraform.workspace}${count.index}"
}

data "template_file" "win_custom_script" {
  template = file("../azure-init/scripts/WindowsInitScript.ps1")
}