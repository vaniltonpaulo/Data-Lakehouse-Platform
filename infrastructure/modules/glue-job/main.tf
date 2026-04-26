resource "aws_iam_role" "glue_role" {
  name = "${var.project_name}-glue-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "${var.project_name}-glue-s3-policy"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.bronze_bucket_name}",
          "arn:aws:s3:::${var.bronze_bucket_name}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = ["s3:PutObject", "s3:DeleteObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::${var.silver_bucket_name}",
          "arn:aws:s3:::${var.silver_bucket_name}/*"
        ]
      }
    ]
  })
}



resource "aws_s3_object" "bronze_to_silver_script" {
  bucket = var.scripts_bucket_name
  key    = "glue/bronze_to_silver.py"
  source = "${path.root}/../../../glue_scripts/bronze_to_silver.py"
  etag   = filemd5("${path.root}/../../../glue_scripts/bronze_to_silver.py")
}

resource "aws_glue_job" "bronze_to_silver" {
  name         = "${var.project_name}-bronze-to-silver-${var.environment}"
  role_arn     = aws_iam_role.glue_role.arn
  glue_version = "4.0"

  number_of_workers = 2
  worker_type       = "G.1X"

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket_name}/${aws_s3_object.bronze_to_silver_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--bronze_bucket"       = var.bronze_bucket_name
    "--silver_bucket"       = var.silver_bucket_name
    "--job-bookmark-option" = "job-bookmark-enable"
  }
}