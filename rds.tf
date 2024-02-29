# Criando Subnet Group para RDS
resource "aws_db_subnet_group" "projeto-sn-db-group" {
  name = "${var.base-tag}-sn-db-group"
  subnet_ids = setunion(
    module.network.public_subnets[*].id,
    module.network.private_subnets[*].id
  )
}


resource "aws_db_instance" "dev" {
  identifier             = var.rds-identifier
  allocated_storage      = 20
  db_name                = var.rds-name
  engine                 = "mysql"
  engine_version         = "8.0.35"
  instance_class         = var.rds-instance-type
  username               = var.rds-username
  password               = var.rds-password
  storage_type           = "gp2"
  skip_final_snapshot    = true
  multi_az               = var.multi-az
  vpc_security_group_ids = [module.security.sg-db.id]
  db_subnet_group_name   = aws_db_subnet_group.projeto-sn-db-group.id

  tags = {
    Name = "${var.base-tag}-rds"
  }
}