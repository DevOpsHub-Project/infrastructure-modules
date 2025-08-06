output "web_security_group_id" {
	description = "Web tier security group ID"
	value       = aws_security_group.web.id
}

output "app_security_group_id" {
	description = "Application tier security group ID"
	value       = aws_security_group.app.id
}

output "db_security_group_id" {
	description = "Database tier security group ID"
	value       = aws_security_group.db.id
}