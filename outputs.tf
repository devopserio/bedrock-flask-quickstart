output "application_url" {
  description = "The URL of the bedrock Flask application"
  value       = "https://${aws_route53_record.bedrockflask.name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.bedrockflask.dns_name
}

output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.bedrockflask[*].id
}

output "ec2_private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.bedrockflask[*].private_ip
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 instance security group"
  value       = aws_security_group.bedrockflask.id
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.bedrockflask.arn
}

output "route53_zone_id" {
  description = "The Zone ID of the Route 53 hosted zone"
  value       = data.aws_route53_zone.domain.zone_id
}

output "rendered_env_template" {
  description = "The rendered .env template for local development"
  value       = data.template_file.env_config_flaskai.rendered
}