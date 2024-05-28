variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "machine_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_tags" {
  description = "Tags to apply to the instances"
  type        = map(string)
  default     = {}
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "security_group_id" {
  description = "security group ID to attach to the instance"
  type        = string
}

variable "ssh_key_bucket" {
  description = "S3 bucket where the SSH key is stored"
  type        = string
}

