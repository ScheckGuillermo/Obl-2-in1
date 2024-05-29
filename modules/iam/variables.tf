variable "role_name" {
  description = "The name of the IAM role"
  type        = string
}

variable "assume_role_policy" {
  description = "The policy that grants an entity permission to assume the role"
  type        = string
}

variable "arn" {
  description = "The ARN of the resource"
  type        = string
}

variable "policies" {
  description = "List of policies to attach to the role"
  type = list(object({
    policy_name     = string
    policy_template = string
  }))
}
