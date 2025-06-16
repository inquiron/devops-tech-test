terraform {
  backend "s3" {
    bucket         = "devops-tfstate-wilfred-20250616"
    key            = "devops-tech-test/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
