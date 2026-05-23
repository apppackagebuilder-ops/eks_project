# Phase 1 Deployment Guide

This guide assumes nothing is preinstalled. Follow the steps in order.

For the complete end-to-end platform build, including EKS add-ons, ArgoCD, Jenkins, Helm deployments, and validation commands, continue with `docs/Execution-Guide.md` after completing the networking bootstrap.

## Step 1: Create an AWS account and administrative access

1. Sign in to AWS or create a new AWS account.
2. Enable MFA on the root account.
3. Create an IAM administrative user only for initial setup.
4. Create a named IAM group for later least-privilege work.

Why this matters:

- The root account should not be used for daily work.
- MFA lowers the risk of account compromise.
- An IAM user gives you auditable access.

## Step 2: Install required tools

### Windows

AWS CLI:

```powershell
winget install Amazon.AWSCLI
```

Terraform:

```powershell
winget install Hashicorp.Terraform
```

Git:

```powershell
winget install Git.Git
```

### macOS

```bash
brew install awscli terraform git
```

### Ubuntu or Debian

```bash
sudo apt-get update
sudo apt-get install -y unzip curl gnupg software-properties-common git
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform
```

## Step 3: Verify installations

Windows PowerShell:

```powershell
aws --version
terraform version
git --version
```

Linux and macOS:

```bash
aws --version
terraform version
git --version
```

Expected result:

- Each command returns a version number.
- If a command is not found, fix the tool installation before continuing.

## Step 4: Configure AWS credentials

```bash
aws configure
```

Provide:

- AWS Access Key ID.
- AWS Secret Access Key.
- Default region such as `us-east-1`.
- Output format `json`.

Validate identity:

```bash
aws sts get-caller-identity
```

Expected result:

- You should see your AWS account ID and IAM user or role ARN.

## Step 5: Review the Terraform environment values

Open `terraform/environments/dev/terraform.tfvars` and review:

- `aws_region`
- `availability_zones`
- `bastion_allowed_cidrs`
- `nat_gateway_mode`

Important:

- Replace `203.0.113.10/32` with your own public IP in CIDR format.
- Keep `create_dns_resources = false` until you really own a public Route53 hosted zone.

To discover your public IP:

```bash
curl ifconfig.me
```

## Step 6: Initialize Terraform

Windows PowerShell:

```powershell
Set-Location e:\eks_project\terraform\environments\dev
terraform init
```

Linux and macOS:

```bash
cd /path/to/eks_project/terraform/environments/dev
terraform init
```

What this does:

- Downloads the AWS provider.
- Prepares the working directory.
- Creates the `.terraform` folder.

## Step 7: Format and validate the code

Windows PowerShell:

```powershell
terraform fmt -recursive
terraform validate
```

Linux and macOS:

```bash
terraform fmt -recursive
terraform validate
```

## Step 8: Review the execution plan

```bash
terraform plan -out phase1.tfplan
```

What to review in the output:

- Number of subnets.
- NAT Gateway count.
- Bastion host creation.
- CloudWatch flow log resources.

## Step 9: Apply the networking stack

```bash
terraform apply phase1.tfplan
```

Expected outputs include:

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `bastion_public_ip`

## Step 10: Validate the AWS resources

List the VPC:

```bash
aws ec2 describe-vpcs --filters Name=tag:Project,Values=acme-eks-platform
```

List subnets:

```bash
aws ec2 describe-subnets --filters Name=vpc-id,Values=<your-vpc-id>
```

List NAT Gateways:

```bash
aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=<your-vpc-id>
```

List flow logs:

```bash
aws ec2 describe-flow-logs --filter Name=resource-id,Values=<your-vpc-id>
```

## Step 11: Destroy resources when you finish the demo

```bash
terraform destroy
```

Why this matters:

- NAT Gateways cost money even when traffic is low.
- Bastion hosts and Elastic IPs also create cost.
