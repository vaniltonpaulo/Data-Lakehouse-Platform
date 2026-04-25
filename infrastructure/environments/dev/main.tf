terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


module "data_lake" {
  source       = "../../modules/s3-data-lake"
  project_name = var.project_name
  environment  = var.environment
}

module "lambda_ingestion" {
  source             = "../../modules/lambda-ingestion"
  project_name       = var.project_name
  environment        = var.environment
  bronze_bucket_name = module.data_lake.bronze_bucket_name
}