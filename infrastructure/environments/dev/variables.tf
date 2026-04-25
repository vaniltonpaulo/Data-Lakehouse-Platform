variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "mylakehouse"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}