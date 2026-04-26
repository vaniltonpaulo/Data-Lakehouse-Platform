output "bronze_bucket_name" {
  value = aws_s3_bucket.bronze.id
}

output "silver_bucket_name" {
  value = aws_s3_bucket.silver.id
}

output "gold_bucket_name" {
  value = aws_s3_bucket.gold.id
}



output "athena_results_bucket_name" {
  value = aws_s3_bucket.athena_results.id
}