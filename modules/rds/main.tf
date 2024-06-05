resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids
  tags       = var.db_subnet_group_tags
}

resource "aws_db_instance" "this" {
  allocated_storage           = var.allocated_storage
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.db_name
  username                    = var.username
  manage_master_user_password = true
  parameter_group_name        = var.parameter_group_name
  skip_final_snapshot         = var.skip_final_snapshot
  publicly_accessible         = var.publicly_accessible

  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  tags = var.tags
}
