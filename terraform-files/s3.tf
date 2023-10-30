provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}
 
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-1234"  # Replace with a unique bucket name
}

