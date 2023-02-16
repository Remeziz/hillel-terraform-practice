data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_ecr_repository" "this"{
  name = aws_ecr_repository.react-app.name
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
