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

resource "aws_ssm_maintenance_window_task" "task" {
  window_id        = "${aws_ssm_maintenance_window.window.id}"
  name             = "maintenance-window-task"
  description      = "This is a maintenance window task"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunShellScript"
  priority         = 1
  service_role_arn = "arn:aws:iam::187416307283:role/service-role/AWS_Events_Invoke_Run_Command_112316643"
  max_concurrency  = "2"
  max_errors       = "1"

  targets {
    key    = "InstanceIds"
    values = ["${aws_instance.instance.id}"]
  }

  task_parameters {
    name   = "commands"
    values = ["pwd"]
  }
}

resource "aws_instance" "instance" {
  ami = "ami-4fccb37f"

  instance_type = "t1.micro"
}
