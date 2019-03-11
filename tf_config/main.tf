variable "aws_access_key" {}
variable "secret_key" {}
variable "ami_id" {}
variable "key_name" {}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.secret_key}"
  region     = "us-east-2"
}

resource "aws_ssm_maintenance_window" "production" {
  name     = "maintenance-window-application"
  schedule = "cron(0 16 ? * TUE *)"
  duration = 3
  cutoff   = 1
}
