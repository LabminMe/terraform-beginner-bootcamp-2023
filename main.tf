terraform {
  cloud {
    organization = "labmin"
    workspaces {
      name = "terra-house-1"
    }
  }
  required_providers {
    random = {
      source = "hashicorp/random" 
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
}

# Configure AWS Provider
provider "aws" {
  # Configuration options
  region = AWS_DEFAULT_REGION
  
}

# Configure the Random Provider
provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length           = 32
  upper            = false
  special          = false
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result

}
output "random_bucket_name"{
    value = random_string.bucket_name.result
}
