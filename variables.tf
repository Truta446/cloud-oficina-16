variable "region" {
  description = "Região da AWS para provisionamento"
  type        = string
}

variable "user" {
  description = "Nome do usuário que esta criando a infra na AWS"
  type        = string
}

variable "base-tag" {
  description = "Nome utilizado para nomenclaruras no projeto"
  type        = string
}

variable "rds-identifier" {
  description = "Tipo da instância do RDS"
  type        = string
}

variable "rds-instance-type" {
  description = "Tipo da instância do RDS"
  type        = string
}

variable "rds-name" {
  description = "Nome do schema criado inicialmente para usar no Projeto"
  type        = string
}

variable "rds-username" {
  description = "Nome do usuário administrador da instância RDS"
  type        = string
}

variable "rds-password" {
  description = "Senha do usuário administrador da instância RDS"
  type        = string
}

variable "bucket-name" {
  description = "Nome do bucket para configurar no Projeto"
  type        = string
}

variable "min-tasks" {
  description = "Quantidade mínima de tasks no autoscaling"
  type        = number
}

variable "max-tasks" {
  description = "Quantidade máxima de tasks no autoscaling"
  type        = number
}

variable "use-nat-gateway" {
  description = "Especifica se serão criados NAT Gateways para cada Subnet pública."
  type        = bool
}

variable "certified-domain" {
  description = "Especifica qual o dominio existente para criação do certificado publico"
  type        = string
}

variable "url" {
  description = "URL do site - Necessário um dóminio e a criação do certificado SSL"
  type        = string
}

variable "prefix-url" {
  description = "URL do site - Necessário um dóminio e a criação do certificado SSL"
  type        = string
}

variable "client" {
  description = "Nome do Cliente, base para nomear os recursos"
  type        = string
}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default     = {}
}

variable "multi-az" {
  description = "Para conseguir diferenciar entre desenvolvimento e produção"
  type        = bool
}

variable "ec2-instance-type" {
  description = "Tipo de instância utilizada no ec2"
  type        = string
}

variable "ec2-ami" {
  description = "ID da imagem"
  type        = string
}

variable "ec2-key-name" {
  description = "NOme do par de chaves"
  type        = string
}