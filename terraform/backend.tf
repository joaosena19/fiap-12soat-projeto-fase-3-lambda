terraform {
  backend "s3" {
    bucket         = "fiap-12soat-terraform-state"
    key            = "lambda-auth/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
