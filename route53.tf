resource "aws_route53_zone" "packy-v2-web-zone" {
  name = "packyforyou.com"
}

resource "aws_route53_record" "packy-v2-web-dev-record" {
  zone_id = aws_route53_zone.packy-v2-web-zone.id
  name = "dev.packyforyou.com"
  type = "A"

  alias {
    name = aws_lb.packy-v2-alb.dns_name
    zone_id = aws_lb.packy-v2-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "packy-v2-web-prod-record" {
  zone_id = aws_route53_zone.packy-v2-web-zone.id
  name = "packyforyou.com"
  type = "A"

  alias {
    name = aws_lb.packy-v2-alb.dns_name
    zone_id = aws_lb.packy-v2-alb.zone_id
    evaluate_target_health = true
  }
}