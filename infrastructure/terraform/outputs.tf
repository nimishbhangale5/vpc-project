output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private.id
}

output "bastion_public_ip" {
  description = "🔐 Bastion Host Public IP — use this to SSH"
  value       = aws_instance.bastion.public_ip
}

output "app_server_private_ip" {
  description = "🖥️ App Server Private IP"
  value       = aws_instance.app_server.private_ip
}

output "nat_gateway_ip" {
  description = "NAT Gateway Elastic IP"
  value       = aws_eip.nat.public_ip
}

output "ssh_bastion_command" {
  description = "Command to SSH into Bastion Host"
  value       = "ssh -i vpc-key ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_app_server_command" {
  description = "Command to SSH into App Server via Bastion"
  value       = "ssh -i vpc-key -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.app_server.private_ip}"
}