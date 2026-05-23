#!/usr/bin/env bash

# Run from the repository root or directly from this script path.

set -euo pipefail

cd "$(dirname "$0")/../terraform/environments/dev"
terraform fmt -recursive
terraform init -backend=false
terraform validate