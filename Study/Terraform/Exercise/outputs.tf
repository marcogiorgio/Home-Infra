output "elb_public_dns" {
  value = aws_alb.alb.dns_name
}

output "bastion_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.bastion_host.public_ip
}