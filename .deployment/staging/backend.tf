terraform {
  backend "s3" {
    bucket         = "terraform-backend-mongodb-ha-bucket"      
    key            = "dmz/terraform.tfstate" 
    region         = "us-east-1"          # e.g. us-east-1
    dynamodb_table = "terraform-backend-mongodb-HA-locks" # replace with your DynamoDB table name for state locking
    encrypt        = true                        
  }
}