terraform {
  required_version = ">= 0.9.0"
  backend "s3" {
    region = "us-east-1"
    bucket = "k8s-terraform-appwork"
    key = "terraform.tfstate"
    profile = "terraform"
  }
}
  
