output "redshift_namespace_name" {
  value = aws_redshiftserverless_namespace.main.namespace_name
}

output "redshift_workgroup_name" {
  value = aws_redshiftserverless_workgroup.main.workgroup_name
}