resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "dev-database-subnet-group-${random_string.secret_suffix.result}"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "Dev database subnet group - bedrock flask"
  }
}


##################################################################################
# POSTGRES DATABASE SECURITY GROUP
##################################################################################

resource "aws_security_group" "db_security_group" {
  name        = "DevOpser DB Security Group"
  description = "Scope for ingress to PostgreSQL database"
  vpc_id      = data.aws_vpc.selected.id

  # Allow incoming connections from the dev instance on PostgreSQL port
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.bedrockflask.id] # Allowing the dev instance's security group
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DevOpser DB Security Group"
  }
}

##################################################################################
# POSTGRES DATABASE INSTANCE (RDS)
##################################################################################

resource "aws_db_instance" "bedrockflask_db" {
  allocated_storage    = 20  # Size in GiBs
  db_subnet_group_name = aws_db_subnet_group.my_subnet_group.name
  storage_type         = "gp2"  # General Purpose SSD
  engine               = "postgres"
  db_name              = var.dev_db_name
  engine_version       = "14.12" # Specify your desired version
  instance_class       = "db.t3.micro" # Choose according to your needs
  username             = var.POSTGRES_USER
  password             = var.POSTGRES_PASSWORD
  skip_final_snapshot  = true
  port                 = var.POSTGRES_PORT

  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  backup_retention_period = 1  # 1 day for dev
  backup_window           = "03:00-04:00" # off-peak hours
  # Automatic backups enabled by default with retention > 0
  
  # Ensure encryption and logging
  storage_encrypted                       = true
  monitoring_interval                     = 0
  performance_insights_enabled            = true
  performance_insights_retention_period   = 7
  
  tags = {
    Name = "bedrockflask-postgresql-db-dev"
  }
}