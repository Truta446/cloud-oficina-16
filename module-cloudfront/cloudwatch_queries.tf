# Material de referência sobre os IPs utilizados nas CDNs na AWS.: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/LocationsOfEdgeServers.html
# Arquivo JSON com a lista de IPs das CDNs na AWS.: https://d7uri8nf7uskq.cloudfront.net/tools/list-cloudfront-ips
# # Referência
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html
# https://aws.amazon.com/pt/premiumsupport/knowledge-center/waf-analyze-logs-stored-cloudwatch-s3/
# https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-baseline.html

# 01 - Default
resource "aws_cloudwatch_query_definition" "Cloudfront" {
  name = "Default"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
CloudFront
parse @message "*    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *    *" as date, time, x_edge_location, sc_bytes, c_ip, cs_method, host, cs_uri_stem, sc_status, referer, useragent, cs_uri_query, cookie, x_edge_result_type, x_edge_request_id, x_host_header, cs_protocol, cs_bytes, time_taken, x_forwarded_for, ssl_protocol, ssl_cipher, x_edge_response_result_type, cs_protocol_version, fle_status, fle_encrypted_fields, c_port, time_to_first_byte, x_edge_detailed_result_type, sc_content_type, sc_content_len, sc_range_start, sc_range_end
| limit 20
| sort @timestamp desc
resource "aws_cloudwatch_query_definition" "Default" {
  name = "Default"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",
    
  ]

  query_string = <<EOF
fields @timestamp, @message
| sort @timestamp desc
EOF
}

resource "aws_cloudwatch_query_definition" "blocks" {
  name = "Consulta de BLOCK"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields httpRequest.clientIp as ClientIP, httpRequest.country as Country, httpRequest.uri as URI, terminatingRuleId as Rule, action as Action
| sort @timestamp desc
| filter action = "BLOCK"
| stats count(*) as RequestCount by @timestamp, Country, ClientIP, URI, Rule, Action
| sort RequestCount desc
EOF
}

resource "aws_cloudwatch_query_definition" "consulta" {
  name = "Consulta de BLOCK por IP"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields @timestamp, @message
| filter httpRequest.clientIp = "186.251.62.123"
| filter action = "BLOCK"
| sort @timestamp desc
EOF
}

resource "aws_cloudwatch_query_definition" "Methods" {
  name = "Methods"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like "Error"
| filter @message like /4{1}[0-9]{1}[0-9]{1}/
| limit 50
EOF
}
resource "aws_cloudwatch_query_definition" "country" {
  name = "country"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
stats count(*) as RequestCount by httpRequest.country as Country
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Request" {
  name = "Request"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
parse @message /\{"name":"[Hh]ost\",\"value":\"(?<Host>[^"}]*)/
| stats count(*) as RequestCount by Host
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "clientIp" {
  name = "clientIp"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
stats count(*) as RequestCount by httpRequest.clientIp as ClientIP
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_Role" {
  name = "Block por Role"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields httpRequest.clientIp as ClientIP, httpRequest.country as Country, httpRequest.uri as URI, terminatingRuleId as Rule, action as Action
| filter action = "BLOCK"
| stats count(*) as RequestCount by Country, ClientIP, URI, Rule, Action
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Path_por_IP" {
  name = "Path por IP"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields httpRequest.clientIp as ClientIP, httpRequest.country as Country, httpRequest.uri as URI, terminatingRuleId as Rule
| filter httpRequest.clientIp = "191.135.83.85"
| stats count(*) as RequestCount by Country, ClientIP, URI, Rule
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_Host" {
  name = "Block por Host"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
parse @message /\{"name":"[Hh]ost\",\"value":\"(?<Host>[^"}]*)/
| filter Host = "www.<APP>.jus.br"
| filter action = "BLOCK"
| fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
EOF
}
resource "aws_cloudwatch_query_definition" "Block_por_origem_Request_ID" {
  name = "Block por origem x Request ID"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "iv3ZZQS1jqn_g0vXnkRSie-fXwCbo4MY4VBPLujwiuX0U48LjF4MWg=="
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "count_por_origem_Request_ID" {
  name = "Count por origem x Request ID"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "V38Y0tDvsQDZO5SDYguA-hyxjB1W3b817rr7ITYx-W3rO-fbY-N90w=="
| stats count(*) as RequestCount by httpRequest.uri 
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "Count_per_Action" {
  name = "Count per Action"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields terminatingRuleId as Rule, action, httpRequest.country as Country, httpRequest.clientIp as ClientIP, httpRequest.uri as URI
| filter httpRequest.requestId = "V38Y0tDvsQDZO5SDYguA-hyxjB1W3b817rr7ITYx-W3rO-fbY-N90w=="
| stats count(*) as RequestCount by httpRequest.uri 
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "filtro_IP_URI" {
  name = "Filtro por IP e por URI"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]

  query_string = <<EOF
fields @timestamp, @message
| filter @message like "187.71.142.245" and @message like "/part-cas/login"
| sort @timestamp desc
| limit 20
EOF
}
resource "aws_cloudwatch_query_definition" "SizeRestrictions_BODY" {
  name = "SizeRestrictions_BODY"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]
  query_string = <<EOF
parse @message '{"name":"content-length","value":"*"' as BodySize
| fields httpRequest.clientIp as ClientIP, nonTerminatingMatchingRules.0.action as Action, httpRequest.uri as URI, nonTerminatingMatchingRules.0.ruleId as RuleGroup, ruleGroupList.6.terminatingRule.ruleId as Rule
| filter Rule = "SizeRestrictions_BODY" and BodySize >= "8000"
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "detail_for_x_URI" {
  name = "detail_for_x_URI"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]
  query_string = <<EOF
parse @message '{"name":"content-length","value":"*"' as BodySize
| fields httpRequest.clientIp as ClientIP, nonTerminatingMatchingRules.0.action as Action, httpRequest.uri as URI, nonTerminatingMatchingRules.0.ruleId as RuleGroup, ruleGroupList.6.terminatingRule.ruleId as Rule
| filter Rule = "SizeRestrictions_BODY" and BodySize >= "8000" and URI = "/proad/pages/fichadoprocesso.xhtml"
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "SizeRestrictions_BODY_size" {
  name = "SizeRestrictions_BODY_size"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]
  query_string = <<EOF
parse @message '{"name":"content-length","value":"*"' as BodySize
| fields httpRequest.clientIp as ClientIP, nonTerminatingMatchingRules.0.action as Action, httpRequest.uri as URI, nonTerminatingMatchingRules.0.ruleId as RuleGroup, ruleGroupList.6.terminatingRule.ruleId as Rule
| filter Rule = "SizeRestrictions_BODY" and BodySize >= "8000" and URI = "/proad/pages/fichadoprocesso.xhtml"
| sort RequestCount desc
EOF
}
resource "aws_cloudwatch_query_definition" "SizeRestrictions_BODY_statitics" {
  name = "SizeRestrictions_BODY_statitics"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]
  query_string = <<EOF
parse @message '{"name":"content-length","value":"*"' as BodySize
| fields httpRequest.clientIp as ClientIP, nonTerminatingMatchingRules.0.action as Action, httpRequest.uri as URI, nonTerminatingMatchingRules.0.ruleId as RuleGroup, ruleGroupList.6.terminatingRule.ruleId as Rule
| filter Rule = "SizeRestrictions_BODY" and BodySize >= "8000" 
| stats max(BodySize) as maxBodysize by Action, URI, RuleGroup, Rule
| sort maxBodysize desc
EOF
}
resource "aws_cloudwatch_query_definition" "URI_X_maxbodysize" {
  name = "URI_X_maxbodysize"

  log_group_names = [
    "/aws/${aws_cloudfront_distribution.cdn.id}",

  ]
  query_string = <<EOF
parse @message '{"name":"content-length","value":"*"' as BodySize
| fields nonTerminatingMatchingRules.0.action as Action, httpRequest.uri as URI,  ruleGroupList.6.terminatingRule.ruleId as Rule
| filter Rule = "SizeRestrictions_BODY" and BodySize >= "8000" 
| stats max(BodySize) as maxBodysize by URI, Rule 
| sort maxBodysize desc
EOF
}