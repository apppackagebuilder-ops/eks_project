output "terraform_state_bucket" {
  description = "S3 bucket name used for Terraform remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "terraform_lock_table" {
  description = "DynamoDB table name used for Terraform state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}
