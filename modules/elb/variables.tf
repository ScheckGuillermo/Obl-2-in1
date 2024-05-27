variable "elb_name" {
  description = "Name of the ELB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ELB will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ELB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to attach to the ELB"
  type        = string
}

variable "instance_ids" {
  description = "List of instance IDs to attach to the ELB"
  type        = list(string)
}
