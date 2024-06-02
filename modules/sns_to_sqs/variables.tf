variable "topic_arn" {
  description = "The ARN of the SNS topic"
  type        = string
}

variable "protocol" {
  description = "The protocol to use for the subscription"
  type        = string
}

variable "endpoint" {
  description = "The endpoint to receive the notifications"
  type        = string
}
