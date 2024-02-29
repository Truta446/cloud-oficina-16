/* data "aws_route53_zone" "selected" {
  name         = var.certified-domain
  private_zone = false
}

resource "aws_route53_record" "origin" {

  zone_id = data.aws_route53_zone.selected.id
  name    = "origin-${var.prefix-url}.${var.certified-domain}"
  type    = "A"
  alias {
    name                   = aws_lb.proj_elb.dns_name
    zone_id                = aws_lb.proj_elb.zone_id
    evaluate_target_health = true
  }
} */