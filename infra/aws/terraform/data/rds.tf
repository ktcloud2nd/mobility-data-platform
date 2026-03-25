resource "aws_db_instance" "this" {
  identifier = "${var.name_prefix}-postgres"

  engine         = "postgres"
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [data.terraform_remote_state.network.outputs.db_sg_id]

  publicly_accessible = false
  multi_az            = false

  backup_retention_period = var.backup_retention_period

  auto_minor_version_upgrade = true
  deletion_protection        = false
  skip_final_snapshot        = true
  apply_immediately          = true

  performance_insights_enabled = false
  monitoring_interval          = 0

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-postgres"
  })
}