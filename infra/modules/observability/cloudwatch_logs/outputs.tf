output "server_log_group_name" {
  value = aws_cloudwatch_log_group.server.name
}

output "consumer_log_group_name" {
  value = aws_cloudwatch_log_group.consumer.name
}
