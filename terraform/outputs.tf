output "instance_public_ip" {
  description = "Public IP address of the DMZ staging EC2 instance"
  value       = aws_instance.dmz.public_ip
}

output "instance_id" {
  description = "ID of the DMZ staging EC2 instance"
  value       = aws_instance.dmz.id
}

output "ssh_command" {
  description = "Preformatted SSH command to connect to the staging instance"
  value       = "ssh -i ~/.ssh/${var.key_name} ubuntu@${aws_instance.dmz.public_ip}"
}
