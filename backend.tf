terraform {
  backend "s3" {
    bucket         = "my-hardik-terraform-state-bucket-786" # Replace with your bucket name
    key            = "network/static-infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table" # Replace with your DynamoDB table name
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}
