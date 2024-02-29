
# VPC Endpoint CloudWatch
resource "aws_vpc_endpoint" "cloudwatch_logs" {
  count             = var.use-nat-gateway ? 0 : 1
  vpc_id            = module.network.vpc_id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-all.id]
  subnet_ids          = module.network.private_subnets[*].id # Select the appropriate private subnet

  tags = {
    Name = "cloudwatch-endpoint-logs"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_monitoring" {
  count             = var.use-nat-gateway ? 0 : 1
  vpc_id            = module.network.vpc_id
  service_name      = "com.amazonaws.${var.region}.monitoring"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-all.id]
  subnet_ids          = module.network.private_subnets[*].id # Select the appropriate private subnet

  tags = {
    Name = "cloudwatch-endpoint-monitoring"
  }
}

# VPC Endpoint S3
resource "aws_vpc_endpoint" "s3_endpoint" {
  # count             = var.use-nat-gateway ? 0 : 1
  vpc_id            = module.network.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = module.network.private_route_tables[*].id

  tags = {
    Name = "s3-endpoint"
  }
}

# VPC Endpoint ELB
resource "aws_vpc_endpoint" "elb_endpoint" {
  count             = var.use-nat-gateway ? 0 : 1
  vpc_id            = module.network.vpc_id
  service_name      = "com.amazonaws.${var.region}.elasticloadbalancing"
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true
  security_group_ids  = [module.security.sg-all.id]
  subnet_ids          = module.network.private_subnets[*].id # Select the appropriate private subnet

  tags = {
    Name = "elb-endpoint"
  }
}
