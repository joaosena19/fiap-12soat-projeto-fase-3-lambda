# Rotas públicas (sem autenticação) - para Lambda de autenticação
resource "aws_apigatewayv2_route" "auth_post" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /auth/authenticate"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_auth.id}"
}

resource "aws_apigatewayv2_route" "webhook_post" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /webhook"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_auth.id}"
}

# Rota protegida (com JWT) - proxy para EKS
resource "aws_apigatewayv2_route" "protected_proxy" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "ANY /api/{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.eks.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}

# Rota para health check (pública)
resource "aws_apigatewayv2_route" "health_get" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.eks.id}"
}

# Rota catch-all protegida para outras rotas da aplicação
resource "aws_apigatewayv2_route" "protected_catchall" {
  api_id             = aws_apigatewayv2_api.main.id
  route_key          = "ANY /{proxy+}"
  target             = "integrations/${aws_apigatewayv2_integration.eks.id}"
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.jwt.id
}