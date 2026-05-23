output "efs_file_system_id" {
  description = "EFS file system ID for shared persistent workloads."
  value       = aws_efs_file_system.this.id
}

output "efs_security_group_id" {
  description = "Security group attached to EFS mount targets."
  value       = aws_security_group.efs.id
}
