# Configurações inicias do projeto com AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
  # Definição do backend - local onde será armazenado o arquivo terraform.tfstate do projeto
  backend "s3" {
    bucket = "terraform-tfstate-php-jversolato"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {

  region = var.region

  default_tags {
    tags = {
      Criado_por = var.user
      IaC        = "terraform"
    }
  }
}
