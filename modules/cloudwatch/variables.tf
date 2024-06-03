variable "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "The number of days to retain the logs"
  type        = number
  default     = 14
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
