# --- PROVEEDOR (La Concesionaria) ---
provider "aws" {
  region = "us-east-1"
}

# --- LLAVES DE ACCESO (El llavero digital) ---
# 1. Generamos un algoritmo de encriptación seguro
resource "tls_private_key" "audi_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Creamos la llave pública en AWS (la cerradura en el auto)
resource "aws_key_pair" "generated_key" {
  key_name   = "audi-project-key"
  public_key = tls_private_key.audi_key.public_key_openssh
}

# 3. Guardamos la llave privada en tu PC (tu copia de la llave)
# OJO: Se creará un archivo llamado "audi-key.pem" en tu carpeta
resource "local_file" "private_key" {
  content  = tls_private_key.audi_key.private_key_pem
  filename = "audi-key.pem"
}

# --- SEGURIDAD (El Garage) ---
resource "aws_security_group" "audi_sg" {
  name        = "audi-security-group"
  description = "Permitir SSH y trafico web para herramientas"

  # Entrada: SSH (Para que tú controles el servidor)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada: HTTP (Web estándar)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada: Puerto 5678 (Para el panel de control de n8n)
  ingress {
    from_port   = 5678
    to_port     = 5678
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida: Internet libre (para bajar actualizaciones)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- CHASIS (Sistema Operativo) ---
# Buscamos el Ubuntu más reciente automáticamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# --- EL AUTO (Instancia EC2) ---
resource "aws_instance" "audi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Capa gratuita

  # Aquí conectamos las piezas anteriores:
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.audi_sg.id]

  tags = {
    Name    = "Audi-Telemetry-Server"
    Project = "Audi-DevOps"
  }
}

# --- RESULTADOS (El Tablero) ---
output "ip_servidor" {
  value = aws_instance.audi_server.public_ip
  description = "IP Publica para conectar"
}

output "comando_conexion" {
  value = "ssh -i audi-key.pem ubuntu@${aws_instance.audi_server.public_ip}"
  description = "Copia esto en tu terminal para entrar"
}