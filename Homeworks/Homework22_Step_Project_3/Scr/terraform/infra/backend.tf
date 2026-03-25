terraform {
  backend "s3" {
    bucket  = "stepproject-3-tf-state-nebomriy-2026"
    key     = "infra/terraform.tfstate"
    region  = "eu-central-1"
    profile = "SAM_4_DANIT"
  }
}
