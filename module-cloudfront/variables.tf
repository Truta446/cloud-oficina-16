# Global Variables
variable "aws_region" {
  description = "AWS Region for deploying resources"
  type        = string
}

variable "cliente" {
  description = "Nome do cliente"
  type        = string
}

## Cache parameters
variable "policy_name" {
  description = "Policy Cache Name"
  type        = string
}

variable "lifecycle_environment" {
  description = "Lifecycle environment for deployment"
  type        = string
}

# Logging Setup
variable "cf_logging_bucket" {
  description = "Bucket for Cloudfront logging"
  type        = string
}
variable "cf_logging_bucket_s3_name" {
  description = "Bucket for Cloudfront logging"
  type        = string
}

variable "s3_prefix" {
  description = "Prefixo do bucket para coleta dos logs"
  type        = string
}

variable "alb_acm_certificate_arn" {
  description = "ARN of the ACM certificate for custom domain name"
  type        = string
}

variable "application_name" {
  description = "Application hosted in this infrastructure"
  type        = string
}

variable "domain_name" {
  description = "Domain name for Cloudfront to point to"
  type        = string
}

variable "cname" {
  description = "Cname used by cloudfront"
  type        = string
}

#Route 53 Parameters
variable "urlip" {
  description = "IP Adress to resolve URL"
  type        = string
}

variable "urlname" {
  description = "URL Adress to resolve URL"
  type        = string
}

variable "tags_sufix" {
  type    = string
  default = ""
}

variable "certified-domain" {
  description = "Domínio do certificado SSL"
  type        = string
}
