terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket  = "palja-terraform-backend"
    key     = "network/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "terraform_remote_state" "azure" {
  backend = "s3"
  config = {
    bucket = "palja-terraform-backend"
    key    = "azure/terraform.tfstate" # azure 파일 경로
    region = "ap-northeast-2"
  }

  # 에러 방지: Azure 배포 전이라 S3에 파일이 없을 때 사용할 기본값
  defaults = {
    outputs = {
      consumer_nat_public_ip = "0.0.0.0" 
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Project   = "ktcloud2nd"
        ManagedBy = "Terraform"
        Component = "network"
      },
      var.tags
    )
  }
}
