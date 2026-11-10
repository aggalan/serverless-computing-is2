output "api_url" {
  description = "Copiar esta URL en la diapositiva 18 (modo AWS REAL)"
  value       = aws_apigatewayv2_stage.default.invoke_url
}

output "lambda_function" {
  value = aws_lambda_function.api.function_name
}

output "dynamodb_table" {
  value = aws_dynamodb_table.registrations.name
}

output "cloudwatch_log_group" {
  value = aws_cloudwatch_log_group.lambda.name
}

output "execution_role_arn" {
  description = "Rol EXISTENTE empleado para ejecutar Lambda; no administrado por Terraform"
  value       = local.execution_role_arn
}
