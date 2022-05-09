output "private_key_id" {
  description = "The private key id for cmdbuild"
  value       = aws_key_pair.private_key.id
}

output "cmdbuild_public_ip" {
  value       = aws_instance.cmdbuild.public_ip
  description = "The CMDBuild EC2 Instance public IP"
}