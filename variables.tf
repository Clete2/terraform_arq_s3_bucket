variable "name" {
  type = string
}

variable "additional_tags" {
  description = "Use AWS default_tags to provide the default tags. You can also pass in a map of tags and have them be applied as well; useful for customer tags"
  type        = map(string)
  default     = null
}
