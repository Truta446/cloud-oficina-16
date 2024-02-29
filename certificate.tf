/* # Criação do certificado digital SSL para o HTTPS
resource "aws_acm_certificate" "elb_cert" {
  domain_name       = data.aws_route53_zone.selected.name
  validation_method = "DNS"
  subject_alternative_names = [
    "*.${data.aws_route53_zone.selected.name}",
    "www.${var.client}.${data.aws_route53_zone.selected.name}",
    "${var.client}.${data.aws_route53_zone.selected.name}",
  ]
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.elb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "elb_cert" {
  certificate_arn         = aws_acm_certificate.elb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
} */