resource "aws_cloudwatch_log_group" "aws_waf_logs" {
  name              = format("%s%s", "aws-waf-logs-", var.application_name)
  retention_in_days = "365"

}
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_configuration" {
  log_destination_configs = [aws_cloudwatch_log_group.aws_waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn
  depends_on              = [aws_cloudwatch_log_group.aws_waf_logs]
}
resource "aws_wafv2_web_acl" "web_acl" {
  name        = format("%s%s", "WAF_CF_WEB_ACL_", var.application_name)
  description = "ACL for Backend/Frontend applications"
  scope       = "CLOUDFRONT"
  #tags        = var.tags-sufix

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = format("%s%s", "WAF_CF_WEB_ACL_", var.application_name)
    sampled_requests_enabled   = true
  }
  default_action {
    allow {}
  }
  rule {
    name     = format("%s%s", "whitelist-", var.application_name)
    priority = 0
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.whitelist.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = format("%s%s", "whitelist-", var.application_name)
      sampled_requests_enabled   = true
    }
  }
  rule {
    name     = format("%s%s", "blacklist-", var.application_name)
    priority = 1
    action {
      block {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blacklist.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = format("%s%s", "blacklist-", var.application_name)
      sampled_requests_enabled   = true
    }
  }
  #50 - AWSManagedRulesBotControlRuleSet
  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 2

    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "Block-AWSManagedRulesBotControlRuleSet"
        }
        # rule_action_override {
        #   action_to_use {
        #     count {}
        #   }
        #   name = "CategorySocialMedia"
        # }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #25 - Amazon IP reputation list
  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 3
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedRulesAmazonIpReputationList"
        }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "AWSManagedIPDDoSList"
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSAWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  #50 - Anonymous IP List
  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"

        # excluded_rule {
        #     name = "HostingProviderIPList"
        # }
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "Block-AWSManagedRulesAnonymousIpList"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSAWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  #200 - Known bad inputs
  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 5

    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          action_to_use {
            block {}
          }
          name = "Block-AWSManagedRulesKnownBadInputsRuleSet"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #200 - Linux operating system
  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 6

    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #200 - SQL database
  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 7

    override_action {
      count {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  #700 - Core rule set
  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 8

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

}