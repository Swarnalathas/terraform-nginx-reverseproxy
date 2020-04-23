variable "AWS_ACCES_KEY" {}
variable "AWS_SECRET_ACCESS" {}
variable "AMI_ID" {}
  


provider "aws" {
  region = "eu-west-2"
  access_key = var.AWS_ACCES_KEY
  secret_key = var.AWS_SECRET_ACCESS
  //nginx_image_id = var.NGINX_AMI
}

resource "aws_security_group" "nginx-reverse-proxy-discovery" {
  name = "nginx-reverse-proxy-discovery"
  description = "nginx-reverse-proxy-discovery"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-reverse-proxy-discovery"
  }
}

resource "aws_instance" "nginx" {
  ami           = var.AMI_ID
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.nginx_aws_sg-instance.name}"
  ]
  
  tags = {
    Name = "nginx-reverse-proxy-discovery"
  } 
}
