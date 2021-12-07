locals {
  tags = {
    Environment = "${upper(var.AZURE_ENV)}"
    ProjectName = "${upper(var.AZURE_SHORT)}"
    CostCentre  = "${title("67/1888")}"
  }
}