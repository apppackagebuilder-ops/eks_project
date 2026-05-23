// Shared library step for consistent Terraform plan and apply behavior across environments.
def call(String action, String terraformBinary) {
  bat "cd terraform\\environments\\dev && \"${terraformBinary}\" init -backend=false"
  if (action == 'plan') {
    bat "cd terraform\\environments\\dev && \"${terraformBinary}\" plan -out dev.tfplan"
  }
  if (action == 'apply') {
    bat "cd terraform\\environments\\dev && \"${terraformBinary}\" apply -auto-approve dev.tfplan"
  }
}
