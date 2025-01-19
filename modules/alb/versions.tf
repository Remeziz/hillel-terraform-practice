terraform {
  required_version = ">= 1.0.7"

  required_providers {
    aws = {
      version = ">= 4.45.0"
      source  = "hashicorp/aws"
    }
  }
}
