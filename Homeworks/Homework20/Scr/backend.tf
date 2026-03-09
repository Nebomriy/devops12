terraform {
  backend "s3" {
    bucket = "danit-terraform-state"
    key    = "nebomriysam/hw_20/terraform.tfstate"
    region = "eu-central-1"
  }
}