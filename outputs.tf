output "application_url" {
  description = "The URL of the OpenAI Flask application"
  value       = "https://${aws_route53_record.openaiflask.name}"
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.openaiflask.dns_name
}

output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = aws_instance.openaiflask[*].id
}

output "ec2_private_ips" {
  description = "The private IP addresses of the EC2 instances"
  value       = aws_instance.openaiflask[*].private_ip
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "The ID of the EC2 instance security group"
  value       = aws_security_group.openaiflask.id
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.openaiflask.arn
}

output "route53_zone_id" {
  description = "The Zone ID of the Route 53 hosted zone"
  value       = data.aws_route53_zone.domain.zone_id
}