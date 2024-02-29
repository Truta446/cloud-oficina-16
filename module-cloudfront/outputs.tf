output "distribution_domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "Cloudfront distribution domain name"
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "Cloudfront distribution ID"
}

output "web_acl_arn" {
  value       = aws_wafv2_web_acl.web_acl.arn
  description = "WAF Web ACL ARN"
}

output "aws_cloudwatch_log_group_arn" {
  value       = aws_cloudwatch_log_group.aws_waf_logs.arn
  description = "WAF log grourps ARN"
}

output "app_url" {
  value       = aws_route53_record.www_cdn.name
  description = "URL da aplicação regitrada no CloudFront"
}