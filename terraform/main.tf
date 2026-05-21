resource "aws_key_pair" "k8s_key" {
  key_name   = "k8s-ssh-key"
  public_key = file(var.ssh_public_key_path)
}

resource "aws_security_group" "k8s_sg" {
  name   = "k8s-sg"
  vpc_id = aws_vpc.k8s_vpc.id

  # SSH from anywhere
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API Server from anywhere
  ingress {
    description = "Allow Kubernetes API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All traffic between nodes inside the VPC
  ingress {
    description = "Allow all internal VPC traffic between nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "master_node" {
  ami                    = var.manual_ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_sub.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = aws_key_pair.k8s_key.key_name
  tags = {
    Name = "K8s-Master-Node"
    Role = "Master"
  }
}

resource "aws_instance" "worker_node" {
  ami                    = var.manual_ami_id
  instance_type          = var.instance_type_worker
  subnet_id              = aws_subnet.public_sub.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  key_name               = aws_key_pair.k8s_key.key_name
  tags = {
    Name = "K8s-Worker-Node"
    Role = "Worker"
  }
}

