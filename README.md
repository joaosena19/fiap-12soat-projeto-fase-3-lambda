# Identificação

Aluno: João Pedro Sena Dainese  
Registro FIAP: RM365182  

Turma 12SOAT - Software Architecture  
Grupo individual  
Grupo 15  

Discord: joaodainese  
Email: joaosenadainese@gmail.com  

## Sobre este Repositório

Este repositório contém apenas parte do projeto completo da Fase 3. Para visualizar a documentação completa, diagramas de arquitetura, e todos os componentes do projeto, acesse: [Documentação Completa - Fase 3](https://github.com/joaosena19/fiap-12soat-projeto-fase-3-documentacao)

## Descrição

Funções AWS Lambda para autenticação: uma função para login (geração de tokens JWT) e uma função authorizer (validação de tokens). Configura API Gateway e acessa o banco PostgreSQL para validação de usuários.

## Tecnologias Utilizadas

- **.NET 8** - Runtime
- **AWS Lambda** - Funções serverless
- **API Gateway** - Roteamento e autorização
- **JWT** - Tokens de autenticação
- **Terraform** - Infraestrutura como código

## Passos para Execução

### 1. Build e Publish

```bash
cd src/AuthLambda
dotnet restore
dotnet build
dotnet publish -c Release -o publish
```

### 2. Deploy

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Diagramas de Arquitetura

Para visualizar os diagramas de arquitetura e componentes desta Lambda Function, consulte a documentação completa: [Diagramas de Componentes (C4)](https://github.com/joaosena19/fiap-12soat-projeto-fase-3-documentacao/blob/main/2.%20Diagramas%20de%20Componentes%20(C4)/1_diagrama_de_componentes_c4.md)