# Define the Route53 zone data source
data "aws_route53_zone" "domain" {
  name         = "${var.domain_name}."
  private_zone = false
}

# Create the ACM certificate
resource "aws_acm_certificate" "openaiflask" {
  domain_name       = "${var.subdomain}.${var.domain_name}"
  validation_method = "DNS"

  tags = {
    Name = "openaiflask-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS records for certificate validation
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
  zone_id         = data.aws_route53_zone.domain.zone_id
}

# Validate the certificate
resource "aws_acm_certificate_validation" "openaiflask" {
  certificate_arn         = aws_acm_certificate.openaiflask.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Create the A record for the subdomain pointing to the ALB
resource "aws_route53_record" "openaiflask" {
  depends_on = [aws_lb.openaiflask]
  zone_id    = data.aws_route53_zone.domain.zone_id
  name       = "${var.subdomain}.${var.domain_name}"
  type       = "A"

  alias {
    name                   = aws_lb.openaiflask.dns_name
    zone_id                = aws_lb.openaiflask.zone_id
    evaluate_target_health = true
  }
}