# Run from the repository root or directly from this script path.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Set-Location "$PSScriptRoot\..\terraform\environments\dev"
terraform fmt -recursive
terraform init -backend=false
terraform validate
