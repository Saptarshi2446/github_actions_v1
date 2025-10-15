# main.tf
provider "aws" {
  region = "us-east-2" # Replace with your desired region
}

resource "aws_security_group" "my_ec2_sg" {
  name        = "my-ec2-sg"
  description = "Allow all inbound and outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]   # Allows from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            # All outbound traffic
    cidr_blocks = ["0.0.0.0/0"]   # To anywhere
  }

  tags = {
    Name = "my-ec2-sg"
  }
}

resource "aws_instance" "my_ec2_instance" {
  count         = 1 # Number of EC2 instances to create
  ami           = "ami-0d1b5a8c13042c939" # Replace with a valid AMI ID for your region
  instance_type = "t3.micro"
  key_name      = "zabbix_server2" # Replace with your EC2 key pair name
  vpc_security_group_ids = [aws_security_group.my_ec2_sg.id] # <-- Attach SG here  
  tags = {
    Name = "MyEC2Instance-${count.index}"
  }
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.my_ec2_instance[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.my_ec2_instance[*].private_ip
}

output "instance_hostnames" {
  description = "Private DNS hostnames of the EC2 instances"
  value       = aws_instance.my_ec2_instance[*].private_dns
}