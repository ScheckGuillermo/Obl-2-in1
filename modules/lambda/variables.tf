variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in your code"
  type        = string
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "filename" {
  description = "The path to the deployment package"
  type        = string
}

variable "queue_url" {
  description = "The URL of the SQS queue"
  type        = string
}

variable "bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role"
  type        = string
}

variable "log_group_name" {
  description = "The name of the CloudWatch Log Group"
  type        = string
}
