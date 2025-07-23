output "public_ip" {
  value = aws_instance.ssrf_server.public_ip
}

output "ssh_command" {
  value = "ssh -i deployer-key.pem ubuntu@${aws_instance.ssrf_server.public_ip}"
}

output "Vulnerable_App" {
  value = "http://${aws_instance.ssrf_server.public_ip}:3000"
}

