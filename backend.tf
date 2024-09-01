terraform {
  backend "s3" {
    bucket = "sns-sqs-terraform-state-bucket" # Replace with your unique S3 bucket name
    key    = "terraform.tfstate"              # Replace with the desired key (path) in the bucket
    region = "us-east-1"                      # Replace with your AWS region
    # dynamodb_table = "terraform-state-lock"         # Optional: For state locking and consistency
    encrypt = true # Enable server-side encryption of the state file
  }
}
