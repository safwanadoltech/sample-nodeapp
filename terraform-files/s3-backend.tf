terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-1234" #replace with your s3 bucket name
    key    = "terraform.tfstate-file"
    region = "us-east-1"
  }
}
