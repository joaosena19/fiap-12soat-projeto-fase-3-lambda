# FIAP 12SOAT - Fase 3 - Lambda Authentication

## Descrição

Lambda Function em .NET 8 para autenticação de usuários via ClientId e ClientSecret, gerando tokens JWT válidos para consumo das APIs protegidas do sistema de Oficina Mecânica.

## Estrutura do Projeto

```
fiap-12soat-projeto-fase-3-lambda/
├── src/
│   └── AuthLambda/
│       ├── Function.cs                         # Handler da Lambda
│       ├── AuthLambda.csproj                   # Projeto .NET 8
│       ├── appsettings.json                    # Configurações (JWT, Credentials)
│       ├── Infrastructure/
│       │   └── Authentication/
│       │       ├── AuthenticationService.cs    # Serviço de autenticação
│       │       ├── TokenService.cs             # Serviço de geração de token JWT
│       │       ├── IAuthenticationService.cs
│       │       ├── ITokenService.cs
│       │       ├── TokenRequestDto.cs          # DTO de request
│       │       └── TokenResponseDto.cs         # DTO de response
│       └── Shared/
│           ├── Exceptions/
│           │   └── DomainException.cs          # Exception customizada
│           └── Enums/
│               └── ErrorType.cs                # Tipos de erro
├── terraform/
│   ├── main.tf                                 # Provider AWS
│   ├── lambda.tf                               # Configuração da Lambda
│   ├── iam.tf                                  # IAM Roles e Policies
│   ├── variables.tf                            # Variáveis do Terraform
│   ├── outputs.tf                              # Outputs (ARN, URL, etc)
│   ├── backend.tf                              # S3 Backend
│   └── provider.tf                             # Required providers
├── .github/
│   └── workflows/
│       ├── deploy.yaml                         # Pipeline de deploy
│       └── destroy.yaml                        # Pipeline de destroy
├── .gitignore
└── README.md
```

## Funcionalidades

- **Autenticação via ClientId/ClientSecret**: Valida credenciais estáticas configuradas
- **Geração de Token JWT**: Retorna token Bearer válido por 1 hora
- **Tratamento de Erros**: Respostas apropriadas (400, 401, 500) com mensagens descritivas
- **CORS Habilitado**: Permite requisições de qualquer origem
- **Lambda Function URL**: Endpoint público para invocação direta

## Pré-requisitos

- .NET 8 SDK
- AWS CLI configurado
- Terraform >= 1.3
- Conta AWS com permissões para criar Lambda, IAM Roles, CloudWatch Logs

## Configuração Local

### 1. Restaurar dependências

```powershell
cd src/AuthLambda
dotnet restore
```

### 2. Build do projeto

```powershell
dotnet build --configuration Release
```

### 3. Publish para deployment

```powershell
dotnet publish --configuration Release --output ./bin/Release/net8.0/publish
```

## Deployment com Terraform

### 1. Inicializar Terraform

```powershell
cd terraform
terraform init
```

### 2. Configurar variáveis

Crie um arquivo `terraform.tfvars` (não commitado):

```hcl
aws_region         = "us-east-1"
environment        = "dev"
jwt_key            = "sua-chave-jwt-aqui"
jwt_issuer         = "OficinaMecanicaApi"
jwt_audience       = "AuthorizedServices"
api_client_id      = "admin"
api_client_secret  = "admin"
```

### 3. Deploy

```powershell
terraform plan
terraform apply
```

### 4. Obter URL da Lambda

```powershell
terraform output lambda_function_url
```

## CI/CD - GitHub Actions

### Secrets necessários

Configure os seguintes secrets no repositório GitHub:

- `AWS_ACCESS_KEY_ID`: Access Key da AWS
- `AWS_SECRET_ACCESS_KEY`: Secret Key da AWS
- `JWT_KEY`: Chave secreta para JWT (base64, 64+ caracteres)
- `JWT_ISSUER`: Issuer do token (default: "OficinaMecanicaApi")
- `JWT_AUDIENCE`: Audience do token (default: "AuthorizedServices")
- `API_CLIENT_ID`: Client ID para autenticação (ex: "admin")
- `API_CLIENT_SECRET`: Client Secret para autenticação (ex: "admin")

### Deploy Pipeline

1. Acesse **Actions** → **Deploy Lambda to AWS**
2. Clique em **Run workflow**
3. Selecione o environment (`dev`, `staging`, `prod`)
4. Confirme

A pipeline irá:
- Build do projeto .NET
- Publish do Lambda
- Deploy via Terraform
- Exibir a Lambda Function URL

### Destroy Pipeline

1. Acesse **Actions** → **Destroy Lambda Infrastructure**
2. Clique em **Run workflow**
3. Digite `destroy` no campo de confirmação
4. Confirme

⚠️ **ATENÇÃO**: Esta ação irá destruir **TODOS** os recursos da Lambda (função, logs, IAM roles).

## Uso da API

### Endpoint

```
POST https://<lambda-url>/
```

### Request

```json
{
  "clientId": "admin",
  "clientSecret": "admin"
}
```

### Response (200 OK)

```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "tokenType": "Bearer",
  "expiresIn": 3600
}
```

### Response (401 Unauthorized)

```json
{
  "error": "Credenciais inválidas.",
  "statusCode": 401
}
```

### Response (400 Bad Request)

```json
{
  "error": "ClientId e ClientSecret requeridos.",
  "statusCode": 400
}
```

## Teste Local (sem Lambda)

```powershell
cd src/AuthLambda
dotnet run
```

## Monitoramento

### CloudWatch Logs

Os logs da Lambda são automaticamente enviados para:

```
/aws/lambda/fiap-oficina-auth-lambda
```

Acesse pelo console AWS: **CloudWatch** → **Log Groups**

### Métricas

- **Invocations**: Número de invocações
- **Duration**: Tempo de execução
- **Errors**: Erros durante execução
- **Throttles**: Requisições limitadas

## Segurança

- ✅ Credenciais armazenadas como variáveis de ambiente Lambda
- ✅ Secrets gerenciados via GitHub Actions Secrets
- ✅ IAM Role com permissões mínimas (CloudWatch Logs apenas)
- ✅ Token JWT com expiração de 1 hora
- ✅ CORS configurado (ajustar `allow_origins` em produção)

## Troubleshooting

### Erro: "Configuração JWT está ausente"

Verifique se as variáveis de ambiente estão configuradas no Terraform:
- `Jwt__Key`
- `Jwt__Issuer`
- `Jwt__Audience`

### Erro: "No declaration found for var.xxx"

Execute `terraform init` novamente e verifique se `variables.tf` está presente.

### Lambda retorna 500

Verifique os logs no CloudWatch:

```powershell
aws logs tail /aws/lambda/fiap-oficina-auth-lambda --follow
```

## Próximos Passos (Fase 3)

- [ ] Integração com API Gateway
- [ ] Autenticação via CPF (consulta ao Aurora PostgreSQL)
- [ ] VPC Configuration (acesso ao banco privado)
- [ ] Validação de status do cliente no banco
- [ ] Implementar refresh token
- [ ] Rate limiting
- [ ] Observabilidade com X-Ray

## Licença

Projeto acadêmico - FIAP 12SOAT

## Contato

Equipe FIAP 12SOAT - Fase 3