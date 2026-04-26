output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}


output "silver_database_name" {
  value = aws_glue_catalog_database.silver.name
}

output "silver_crawler_name" {
  value = aws_glue_crawler.silver.name
}

output "bronze_to_silver_job_name" {
  value = aws_glue_job.bronze_to_silver.name
}