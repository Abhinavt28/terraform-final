output "public_ip" {
  value       = aws_instance.public.public_ip
  description = "Public IP of the public EC2 instance"
}
