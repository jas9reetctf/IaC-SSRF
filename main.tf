provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "ssrf_sg" {
  name        = "ssrf-sg"
  description = "Allow HTTP and SSH"
  ingress {
    description = "Allow SSH access from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow to Access Application"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ssrf_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 (update as needed)
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssrf_sg.id]

metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"   # Enforces IMDSv2
    http_put_response_hop_limit = 1
  }

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "SSRF - Exploit AWS MetaData"
  }
}

# Save private key locally (use with ssh later)
resource "local_file" "private_key" {
  content              = tls_private_key.ssh_key.private_key_pem
  filename             = "${path.module}/deployer-key.pem"
  file_permission      = "0600"
  lifecycle {
    prevent_destroy = false
  }
}

