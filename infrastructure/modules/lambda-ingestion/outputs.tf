output "lambda_role_arn" {
  value = aws_iam_role.lambda_exec.arn
}


output "lambda_function_name" {
  value = aws_lambda_function.ingestion.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.ingestion.arn
}