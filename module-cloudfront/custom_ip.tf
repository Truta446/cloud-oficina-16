resource "aws_wafv2_ip_set" "whitelist" {
  name               = format("%s%s", "whitelist-", var.application_name)
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = [""]
}
resource "aws_wafv2_ip_set" "blacklist" {
  name               = format("%s%s", "blacklist-", var.application_name)
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = [""]
}