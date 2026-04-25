# ── KEY PAIR ──
resource "aws_key_pair" "vpc_key" {
  key_name   = "${var.project_name}-key"
  public_key = file("${path.root}/../../vpc-key.pub")

  tags = {
    Name        = "${var.project_name}-key"
    Environment = var.environment
  }
}

# ── BASTION HOST (Public Subnet) ──
resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  key_name                    = aws_key_pair.vpc_key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    echo "Bastion Host Ready!" > /tmp/bastion.txt
  EOF

  tags = {
    Name        = "${var.project_name}-bastion"
    Environment = var.environment
    Role        = "Bastion Host"
  }
}

# ── APP SERVER (Private Subnet) ──
resource "aws_instance" "app_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  key_name                    = aws_key_pair.vpc_key.key_name
  vpc_security_group_ids      = [aws_security_group.app_server.id]
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>OrbitStore App Server 🛸</h1><p>Running in Private Subnet!</p>" > /var/www/html/index.html
  EOF

  tags = {
    Name        = "${var.project_name}-app-server"
    Environment = var.environment
    Role        = "App Server"
  }
}