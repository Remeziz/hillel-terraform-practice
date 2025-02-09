resource "aws_instance" "this" {
  instance_type = var.instance_type
  ami           = data.aws_ami.awslinux.id

  key_name = "all"

  root_block_device {
    volume_size = var.root_block_size
  }

  user_data     = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo aws ecr get-login-password --region=us-west-1 | docker login --username AWS --password-stdin "${var.aws_ecr_repository_url}"
sudo docker run -d --name app -p 8080:80 "${var.aws_ecr_repository_url}":test
  EOF
  
  iam_instance_profile   = var.instance_profile
  vpc_security_group_ids = [var.security_group_id]
 
  
  tags = {
    Name = var.instance_name
    Test = "Test"
  }

  #  lifecycle {
  #    ignore_changes = [user_data]
  #  }
}