output "elb_dns_name" {
  description = "DNS name of the ELB"
  value       = aws_lb.app_lb.dns_name
}

output "elb_arn" {
  description = "ARN of the ELB"
  value       = aws_lb.app_lb.arn
}
