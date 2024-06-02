variable "queue_name" {
  description = "The name of the SQS queue"
  type        = string
}

variable "queue_tags" {
  description = "A map of tags to assign to the queue"
  type        = map(string)

}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message"
  type        = number
  default     = 345600
}

variable "topic_name" {
  description = "The name of the SNS topic"
  type        = string
}

variable "topic_tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
