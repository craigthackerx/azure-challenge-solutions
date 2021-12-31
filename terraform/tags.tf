locals {
  tags = {
    Environment = "${upper(terraform.workspace)}"
    ProjectName = "${upper(var.AZURE_SHORT)}"
    CostCentre  = "${title("67/1888")}"
  }
}