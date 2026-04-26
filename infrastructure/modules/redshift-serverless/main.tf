resource "aws_redshiftserverless_namespace" "main" {
  namespace_name = "${var.project_name}-${var.environment}"
  db_name        = "analytics"
  admin_username      = "admin"
  admin_user_password = jsondecode(data.aws_secretsmanager_secret_version.redshift_password.secret_string)["password"]
}

resource "aws_redshiftserverless_workgroup" "main" {
  namespace_name = aws_redshiftserverless_namespace.main.namespace_name
  workgroup_name = "${var.project_name}-wg-${var.environment}"
  base_capacity  = 8
}


data "aws_secretsmanager_secret_version" "redshift_password" {
  secret_id = "${var.project_name}/redshift/admin-password"
}

