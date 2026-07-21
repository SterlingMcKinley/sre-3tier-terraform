output "alb_dns_name" {
  value       = "http://${aws_lb.web.dns_name}"
  description = "Public URL for Application Load Balancer"
}

output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "Private endpoint connection string for RDS"
}

output "asg_name" {
  value       = aws_autoscaling_group.app.name
  description = "Auto Scaling Group Name"
}

output "fis_role_arn" {
  value       = aws_iam_role.fis_role.arn
  description = "IAM Role ARN to attach to AWS Fault Injection Simulator"
}