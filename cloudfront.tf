/* 
module "multi" {
  source = "./module-cloudfront"

  aws_region                = var.region
  policy_name               = "policy-cloudfront-${var.prefix-url}"
  lifecycle_environment     = "${var.url}-prod"
  cf_logging_bucket         = format("%s%s%s", "cloudfront-logging-", var.user, ".s3.amazonaws.com") #"cloudfront-logging-site.s3.amazonaws.com"
  cf_logging_bucket_s3_name = format("%s%s", "cloudfront-logging-", var.user)                        # Usado pelo Cloudformation
  s3_prefix                 = format("%s%s", var.prefix-url, "/")
  alb_acm_certificate_arn   = aws_acm_certificate_validation.elb_cert.certificate_arn
  application_name          = var.prefix-url
  domain_name               = "origin-${var.url}"
  cname                     = var.url
  urlip                     = aws_lb.proj_elb.dns_name
  urlname                   = var.url
  cliente                   = var.client
  tags_sufix                = var.base-tag
  certified-domain          = var.certified-domain
}

# Criação do bucket para armazenamento dos logs do CloudFront para consulta no CloudWatch
module "s3_bucket" {
  source                 = "./s3-bucket"
  cf_logging_bucket_name = format("%s%s", "cloudfront-logging-", var.user) #"cloudfront-logging-site"
  prefix                 = var.prefix-url
} */