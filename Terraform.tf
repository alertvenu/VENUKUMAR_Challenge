provider "aws" {
  region = "us-east-1"
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

# Create a Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main_subnet"
  }
}

# Create a Security Group allowing HTTP and HTTPS traffic
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "web_sg"
  }
}

# Create an EC2 Instance with a basic web server
resource "aws_instance" "web_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main_subnet.id
  security_groups = [aws_security_group.web_sg.name]

  # User data to install Apache and serve a "Hello World" page
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y apache2
              echo '<html><head><title>Hello World</title></head><body><h1>Hello World!</h1></body></html>' > /var/www/html/index.html
              systemctl start apache2
              systemctl enable apache2
              EOF

  tags = {
    Name = "web_instance"
  }
}

# Create an ACM certificate for HTTPS (optional, can be skipped if using self-signed)
resource "aws_acm_certificate" "certificate" {
  domain_name       = "your-domain.com"   # Replace with your domain
  validation_method = "DNS"

  tags = {
    Name = "my-cert"
  }
}

# Create an Elastic Load Balancer (ELB)
resource "aws_elb" "web_elb" {
  name               = "web-elb"
  availability_zones = ["us-east-1a"]
  security_groups    = [aws_security_group.web_sg.id]

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  listener {
    instance_port     = 443
    instance_protocol = "HTTPS"
    lb_port           = 443
    lb_protocol       = "HTTPS"
    ssl_certificate_id = aws_acm_certificate.certificate.arn
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  instances = [aws_instance.web_instance.id]

  tags = {
    Name = "web_elb"
  }
}

# Output the ELB DNS name to access the web server
output "elb_dns_name" {
  value = aws_elb.web_elb.dns_name
}
