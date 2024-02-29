
resource "aws_cloudfront_distribution" "cdn" {

  comment         = format("%s%s", "Cloudfront distribution for ", var.cliente)
  price_class     = "PriceClass_All"
  enabled         = true
  is_ipv6_enabled = true
  web_acl_id      = aws_wafv2_web_acl.web_acl.arn


  viewer_certificate {
    acm_certificate_arn            = var.alb_acm_certificate_arn
    iam_certificate_id             = ""
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  aliases = [
    "www.${var.cname}"
  ]

  origin {

    origin_id   = "www.${var.cname}"
    domain_name = format("%s%s", "origin-", var.cname)

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  default_cache_behavior {
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    #cache_policy_id = aws_cloudfront_cache_policy.cf_cache_policy.id #var.cache_policy_id
    origin_request_policy_id = "216adef6-5c7f-47e4-b989-5492eafa07d3"
    #origin_request_policy_id = aws_cloudfront_origin_request_policy.cf_origin_request_policy.id #var.origin_request_policy_id
    target_origin_id       = "www.${var.cname}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  logging_config {
    bucket = var.cf_logging_bucket
    prefix = var.application_name
  }
}

# Configuração do DNS no Route 53 para utilização do CloudFront
data "aws_route53_zone" "selected" {
  name         = var.certified-domain
  private_zone = false
}

resource "aws_route53_record" "www_cdn" {

  zone_id = data.aws_route53_zone.selected.id
  name    = "www.${var.application_name}.${var.certified-domain}"
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }
}