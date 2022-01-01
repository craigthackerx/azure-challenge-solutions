variable "loc" {
  description = "The shorthand name of the Azure location, for example, for UK South, use uks.  For UK West, use ukw"
  default     = "uks"
}

variable "win_count" {
  description = "The number to be assigned to the count index for Windows VMs"
  default     = "0"
}

variable "lnx_count" {
  description = "The number to be assigned to count index of Linux VMs"
  default     = "0"
}