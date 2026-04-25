terraform {
  backend "s3" {
    bucket         = "lakehouse-tf-state"
    key            = "dev/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}