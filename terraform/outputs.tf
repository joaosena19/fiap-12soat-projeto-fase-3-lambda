output "lambda_function_arn" {
  description = "ARN da função Lambda"
  value       = aws_lambda_function.auth_lambda.arn
}

output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.auth_lambda.function_name
}

output "lambda_function_url" {
  description = "URL da função Lambda"
  value       = aws_lambda_function_url.auth_lambda_url.function_url
}

output "lambda_execution_role_arn" {
  description = "ARN da role de execução da Lambda"
  value       = aws_iam_role.lambda_execution_role.arn
}
