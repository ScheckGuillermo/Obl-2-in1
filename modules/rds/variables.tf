variable "allocated_storage" {
  description = "The amount of storage allocated for the database (in gigabytes)."
  type        = number
}

variable "engine" {
  description = "The name of the database engine to be used for this DB instance."
  type        = string
}

variable "engine_version" {
  description = "The version number of the database engine to use."
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "username" {
  description = "The username for the master DB user."
  type        = string
}

variable "parameter_group_name" {
  description = "The name of the DB parameter group to associate with this instance."
  type        = string
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted."
  type        = bool
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  type        = bool
}

variable "security_group_id" {
  description = "security group id for the RDS instance."
  type        = string
}

variable "db_subnet_group_name" {
  description = "The DB subnet group to associate with this instance."
  type        = string
}

variable "subnet_ids" {
  description = "The subnets IDs for the DB subnet group."
  type        = list(string)
}

variable "db_subnet_group_tags" {
  description = "Tags to assign to the DB subnet group."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}
