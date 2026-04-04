terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "~> 6.0"
}
}
}
provider "aws" {
region = "us-east-1"
shared_credentials_files = ["./credentials"]
default_tags {
tags = {
Environment = "Dev"
Course = "CSSE6400"
StudentID = "<Your Student ID>"
}
}
}