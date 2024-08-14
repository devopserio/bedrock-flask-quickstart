resource "aws_acm_certificate" "openaiflask" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "openaiflask-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.openaiflask.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.devopser.zone_id
}

resource "aws_acm_certificate_validation" "openaiflask" {
  certificate_arn         = aws_acm_certificate.openaiflask.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

data "aws_route53_zone" "domain" {
  name         = "${var.domain_name}."
  private_zone = false  # Ensure this is set to false for a public zone
}

resource "aws_route53_record" "openaiflask" {
  depends_on = [ aws_lb.openaiflask ]
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.openaiflask.dns_name
    zone_id                = aws_lb.openaiflask.zone_id
    evaluate_target_health = true
  }
}