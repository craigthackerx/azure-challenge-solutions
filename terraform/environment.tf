variable "short" {
  description = "This is passed as an environment variable, it is for a shorthand name for the environment, for example hello-world = hw"
}

variable "env" {
  description = "This is passed as an environment variable, it is for the shorthand environment tag for resource.  For example, production = prod"
}

variable "loc" {
  description = "The shorthand name of the Azure location, for example, for UK South, use uks.  For UK West, use ukw"
  default     = "euw"
}