resource "aws_acm_certificate" "packy-v2-web-acm-wildcard" {
  domain_name = "*.packyforyou.com"
  validation_method = "DNS"

  tags = {
    Name = "packy-v2-web-acm-wildcard"
  }
}

resource "aws_route53_record" "packy-v2-web-acm-record" {
  zone_id = aws_route53_zone.packy-v2-web-zone.zone_id
  name = element(aws_acm_certificate.packy-v2-web-acm-wildcard.domain_validation_options[*].resource_record_name, 0)
  type = element(aws_acm_certificate.packy-v2-web-acm-wildcard.domain_validation_options[*].resource_record_type, 0)
  ttl = 60
  records = [ element(aws_acm_certificate.packy-v2-web-acm-wildcard.domain_validation_options[*].resource_record_value, 0) ]
}

resource "aws_acm_certificate_validation" "packy-v2-web-acm-valiation" {
  certificate_arn = aws_acm_certificate.packy-v2-web-acm-wildcard.arn

  validation_record_fqdns = [ aws_route53_record.packy-v2-web-acm-record.fqdn ]
}