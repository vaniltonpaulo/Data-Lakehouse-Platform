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



module "glue_job" {
  source              = "../../modules/glue-job"
  project_name        = var.project_name
  environment         = var.environment
  bronze_bucket_name  = module.data_lake.bronze_bucket_name
  silver_bucket_name  = module.data_lake.silver_bucket_name
  scripts_bucket_name = module.data_lake.bronze_bucket_name
}


# we will work on this later 
#redshift is a bit price

#module "redshift_serverless" {
# source       = "../../modules/redshift-serverless"
# project_name = var.project_name
#  environment  = var.environment
#}



module "athena" {
  source                     = "../../modules/athena"
  project_name               = var.project_name
  environment                = var.environment
  athena_results_bucket_name = module.data_lake.athena_results_bucket_name
}


module "step_functions" {
  source        = "../../modules/step-functions"
  project_name  = var.project_name
  environment   = var.environment
  lambda_arn    = module.lambda_ingestion.lambda_function_arn
  glue_job_name = module.glue_job.bronze_to_silver_job_name
  crawler_name  = module.glue_job.silver_crawler_name
}