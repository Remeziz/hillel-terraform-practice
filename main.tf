terraform {
  backend "s3" {
    bucket         = "hillel-devops-terraform-state-2"
    key            = "lesson25/terraform/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "my-terraform-lock-table"
  }
}

provider "aws" {
  region = "us-west-1"
}

module "alb" {
  source = "./modules/alb"

  name           = "react-alb"
  my_ip          = "${local.my_ip}"
  instance_ids   = [for host in module.my_host : host.instance_id]
  instance_sg_id = aws_security_group.my_host.id
}

module "my_host" {
  source = "./modules/instance"

  for_each = {
    "first_instance" : {
      "instance_type" : "t2.micro",
      "root_block_size" : 10,
      "root_volume_type" : "gp3"
    },
    # "second_instance" : {
    #   "instance_type" : "t2.micro",
    #   "root_block_size" : 10,
    #   "root_volume_type" : "gp3"
    # },
  }
  
  instance_name          = each.key
  instance_type          = each.value.instance_type
  root_block_size        = each.value.root_block_size
  root_volume_type       = lookup(each.value, "root_volume_type", "standard")
  instance_profile       = aws_iam_instance_profile.ecr_read_and_push.name
  security_group_id      = aws_security_group.my_host.id
  aws_ecr_repository_url = aws_ecr_repository.react-app.repository_url
}

resource "aws_ecr_repository" "react-app" {
  name         = "react-realworld-app"
  force_delete = true
}

resource "null_resource" "this" {
 depends_on = [aws_ecr_repository.react-app]
 provisioner "local-exec" {
    command = <<EOF
sudo rm -rf /tmp/app
sudo yum install git
sudo yum install docker
sudo systemctl start docker
sudo git clone https://github.com/vladyslav-tripatkhi/react-redux-realworld-example-app.git /tmp/app
cd /tmp/app
sudo docker build --platform linux/amd64 -t ${aws_ecr_repository.react-app.repository_url}:test .
sudo aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin ${aws_ecr_repository.react-app.repository_url}
sudo docker push ${aws_ecr_repository.react-app.repository_url}:test
    EOF 
  }
}


#testsdsd