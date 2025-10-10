# main.tf
provider "aws" {
  region = "us-east-2" # Replace with your desired region
}

resource "aws_instance" "my_ec2_instance" {
  count         = 3 # Number of EC2 instances to create
  ami           = "ami-0d1b5a8c13042c939" # Replace with a valid AMI ID for your region
  instance_type = "t3.micro"
  key_name      = "zabbix_server2" # Replace with your EC2 key pair name
  tags = {
    Name = "MyEC2Instance-${count.index}"
  }
}