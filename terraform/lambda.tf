# Fonte de dados para criar arquivo zip do código da Lambda
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src/AuthLambda/bin/Release/net8.0/publish"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda Function para Login (geração de tokens)
resource "aws_lambda_function" "login" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_identifier}-login-lambda"
  role            = aws_iam_role.lambda_execution_role.arn
  handler         = "AuthLambda::AuthLambda.LoginHandler::FunctionHandler"
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
    Name = "${var.project_identifier}-login-lambda"
  }
}

# Lambda Function para Authorizer (validação de tokens)
resource "aws_lambda_function" "authorizer" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_identifier}-authorizer-lambda"
  role            = aws_iam_role.lambda_execution_role.arn
  handler         = "AuthLambda::AuthLambda.AuthorizerHandler::FunctionHandler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime         = var.lambda_runtime
  timeout         = var.lambda_timeout
  memory_size     = var.lambda_memory_size

  environment {
    variables = {
      Jwt__Key      = var.jwt_key
      Jwt__Issuer   = var.jwt_issuer
      Jwt__Audience = var.jwt_audience
    }
  }

  tags = {
    Name = "${var.project_identifier}-authorizer-lambda"
  }
}
