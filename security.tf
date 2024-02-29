# Módulo de criação dos Security Groups para utilização no projeto
module "security" {
  source     = "./module-web-security"
  db-name    = "Mysql"
  db-port    = 3306
  region     = var.region
  tags-sufix = var.base-tag
  vpc-id     = module.network.vpc_id
}

