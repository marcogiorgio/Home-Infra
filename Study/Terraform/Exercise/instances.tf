resource "aws_instance" "http_servers" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "ec2_key_pair"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.public_subnet_sg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = "false"

  count = var.server_instances
  tags = {
    name : "http_servers_${count.index}"
  }

  depends_on = [aws_nat_gateway.nat_gateway]

  user_data = <<-EOL
  #!/bin/bash -xe

   sudo yum install httpd -y
   sudo service httpd start
   echo Virtual Server is at $HOSTNAME | sudo tee /var/www/html/index.html
   EOL
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = "PUBLIC_KEY"
}

#***********************************Load balancer*****************************************
resource "aws_alb" "alb" {
  name            = "alb"
  subnets         = [for subnet in aws_subnet.internet_subnet : subnet.id]
  security_groups = [aws_security_group.internet_subnet_sg.id]
  tags = {
    name = "alb"
  }
}

resource "aws_alb_listener" "alb_http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_group" {
  name     = "alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  stickiness {
    type = "lb_cookie"
  }
}

resource "aws_lb_target_group_attachment" "alb_group_attachment" {
  count            = length(aws_instance.http_servers)
  target_group_arn = aws_alb_target_group.alb_group.arn
  target_id        = aws_instance.http_servers[count.index].id
  port             = 80

}



# Bastion host in internet subnet allowing SSH connection to host in public subnet

resource "aws_instance" "bastion_host" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  key_name                    = "ec2_key_pair"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  subnet_id                   = aws_subnet.internet_subnet[0].id
  associate_public_ip_address = "true"

  tags = {
    name : "bastion_host"
  }
}

# Security group to use for bastion host, allowing SSH in from home IP
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH from home IP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.home_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion_sg"
  }
}