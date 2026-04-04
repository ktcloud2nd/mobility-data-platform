output "lambda_function_name" {
  description = "Slack anomaly notifier Lambda function name."
  value       = aws_lambda_function.notifier.function_name
}

output "lambda_function_arn" {
  description = "Slack anomaly notifier Lambda function ARN."
  value       = aws_lambda_function.notifier.arn
}

output "lambda_security_group_id" {
  description = "Security group attached to the notifier Lambda."
  value       = aws_security_group.lambda.id
}

# Azure가 호출할 Lambda URL
output "lambda_function_url" {
  description = "Public Function URL for the Slack anomaly notifier Lambda."
  value       = aws_lambda_function_url.notifier.function_url
}