# Fonte de dados para criar arquivo zip do código da Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/AuthLambda/bin/Release/net8.0/publish"
  output_path = "${path.module}/lambda_function.zip"
}

# Função Lambda
resource "aws_lambda_function" "auth_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  role            = aws_iam_role.lambda_execution_role.arn
  handler         = "AuthLambda::AuthLambda.Function::FunctionHandler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      Jwt__Key                      = var.jwt_key
      Jwt__Issuer                   = var.jwt_issuer
      Jwt__Audience                 = var.jwt_audience
      ApiCredentials__ClientId      = var.api_client_id
      ApiCredentials__ClientSecret  = var.api_client_secret
    }
  }

  tags = {
    Name = var.lambda_function_name
  }
}

# URL da função Lambda (para invocação direta sem API Gateway)
resource "aws_lambda_function_url" "auth_lambda_url" {
  function_name      = aws_lambda_function.auth_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_origins     = ["*"]
    allow_methods     = ["POST", "OPTIONS"]
    allow_headers     = ["content-type", "authorization"]
    expose_headers    = ["content-type"]
    max_age          = 3600
  }
}
