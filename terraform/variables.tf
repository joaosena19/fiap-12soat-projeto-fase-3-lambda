variable "aws_region" {
  description = "AWS region onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "project_identifier" {
  description = "Identificador do projeto para nomeação de recursos"
  type        = string
  default     = "fiap-12soat-projeto"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "fiap-oficina-auth-lambda"
}

variable "lambda_runtime" {
  description = "Runtime da função Lambda"
  type        = string
  default     = "dotnet8"
}

variable "lambda_timeout" {
  description = "Timeout da função Lambda em segundos"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Memória alocada para a função Lambda em MB"
  type        = number
  default     = 512
}

variable "jwt_key" {
  description = "Chave secreta para geração de tokens JWT"
  type        = string
  sensitive   = true
}

variable "jwt_issuer" {
  description = "Issuer do token JWT"
  type        = string
  default     = "OficinaMecanicaApi"
}

variable "jwt_audience" {
  description = "Audience do token JWT"
  type        = string
  default     = "AuthorizedServices"
}

variable "api_client_id" {
  description = "Client ID para autenticação"
  type        = string
  sensitive   = true
}

variable "api_client_secret" {
  description = "Client Secret para autenticação"
  type        = string
  sensitive   = true
}

# Variáveis para remote state da infraestrutura
variable "infra_terraform_state_bucket" {
  description = "Nome do bucket S3 onde está o state da infraestrutura"
  type        = string
  default     = "fiap-12soat-fase3-joao-dainese"
}
