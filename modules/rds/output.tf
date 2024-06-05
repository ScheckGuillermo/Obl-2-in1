output "db_instance_endpoint" {
  description = "The connection endpoint for the RDS instance."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_identifier" {
  description = "The RDS instance identifier."
  value       = aws_db_instance.this.id
}
