output "vpc_id" {
  description = "ID of the VPC that will host the EKS platform."
  value       = aws_vpc.this.id
}

output "vpc_cidr_block" {
  description = "CIDR range assigned to the VPC."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs keyed by Availability Zone."
  value       = { for az, subnet in aws_subnet.public : az => subnet.id }
}

output "private_subnet_ids" {
  description = "Private subnet IDs keyed by Availability Zone."
  value       = { for az, subnet in aws_subnet.private : az => subnet.id }
}

output "internet_gateway_id" {
  description = "Internet Gateway ID attached to the VPC."
  value       = aws_internet_gateway.this.id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs keyed by the Availability Zone that hosts each NAT Gateway."
  value       = { for az, gateway in aws_nat_gateway.this : az => gateway.id }
}

output "bastion_instance_id" {
  description = "EC2 instance ID of the bastion host when enabled."
  value       = try(aws_instance.bastion[0].id, null)
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host when enabled."
  value       = try(aws_instance.bastion[0].public_ip, null)
}

output "bastion_security_group_id" {
  description = "Security group attached to the bastion host."
  value       = try(aws_security_group.bastion[0].id, null)
}

output "route53_zone_id" {
  description = "Route53 public hosted zone ID when DNS integration is enabled."
  value       = try(data.aws_route53_zone.this[0].zone_id, null)
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN when certificate creation is enabled."
  value       = try(aws_acm_certificate_validation.this[0].certificate_arn, null)
}
