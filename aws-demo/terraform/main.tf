data "aws_caller_identity" "current" {}

locals {
  execution_role_arn = var.lambda_execution_role_arn != "" ? var.lambda_execution_role_arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.lambda_role_name}"
  function_name      = "${var.project_name}-api"
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../src/app.py"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_dynamodb_table" "registrations" {
  name         = "${var.project_name}-registrations"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "registration_id"

  attribute {
    name = "registration_id"
    type = "S"
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 3
}

resource "aws_lambda_function" "api" {
  function_name    = local.function_name
  role             = local.execution_role_arn
  runtime          = "python3.12"
  handler          = "app.lambda_handler"
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256
  timeout          = 8
  memory_size      = 128

  environment {
    variables = {
      REGISTRATIONS_TABLE = aws_dynamodb_table.registrations.name
    }
  }

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_apigatewayv2_api" "http" {
  name          = "${var.project_name}-http"
  protocol_type = "HTTP"

  # Solo PoC. CORS permite la web local, NO es autenticación.
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["content-type"]
    max_age       = 300
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id                 = aws_apigatewayv2_api.http.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.api.invoke_arn
  integration_method     = "POST"
  payload_format_version = "2.0"
  timeout_milliseconds   = 10000
}

resource "aws_apigatewayv2_route" "routes" {
  for_each = toset(["GET /health", "POST /registrations", "GET /registrations"])

  api_id    = aws_apigatewayv2_api.http.id
  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http.id
  name        = "$default"
  auto_deploy = true

  # Crear y publicar el stage recién cuando las rutas y el permiso de invocación existen.
  # La propagación puede tomar segundos adicionales: el workflow reintenta /health.
  depends_on = [aws_apigatewayv2_route.routes, aws_lambda_permission.api_gateway]

  default_route_settings {
    throttling_burst_limit = 30
    throttling_rate_limit  = 15
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowInvokeFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*"
}
