# tfe_aws_ssm_resource
AWS Maintenance window resource - test

**Prerequisites**
 - Basic of Terraform, which could be gained [here](https://www.terraform.io/intro/index.html)
 - Basic knowledge of Terraform Enterprise, or click [here](https://www.terraform.io/docs/enterprise/getting-started/index.html) to learn more about it.
 - Terraform Enterprise account
 - Terraform CLI should be installed on your computer
 - AWS account

In this example  will be explained how to deal with a
resource which was deleted manually from the AWS console, which leads
to inconsistency in the .tfstate file thus leading to an error 
while we try to perform a terraform operation.

The resource that is going to be used in this example is `aws_ssm_maintenance_window`


**TO-DO** 

- Thorough README file


**DONE**

- Create terraform configuration file which: 
  - has an ssm maintenance window resource 
  - has TFE as remote backend


1. Prepare test `main.tf`

 - Add AWS related information to allow Terraform to connect and manage resources
   
   - Add Variables which will hold aws related information: 

   **NOTE**:
   ```
   variable "aws_access_key" {}
   variable "aws_secret_key" {}
   variable "ami_id" {}
   variable "key_name" {}
   variable "aws_arn" {}
   ```
- Add aws provider configuration:
  ```
    provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "us-east-2"
  }
  ```
- Add configuration for the resources that should be created: 
  
  ```
  resource "aws_ssm_maintenance_window" "window" {
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
    service_role_arn = "${var.aws_arn}"
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
    ami = "${var.ami_id}"
  
    instance_type = "t2.micro"
  }
  ```

 - Commit your code to GitHub (or your VCS of choice) and merge it to your master branch.

 - Create a new workspace in [Terraform Enterprise](app.terraform.io)
   - more on how to do it [here](https://www.terraform.io/docs/enterprise/workspaces/creating.html)

 - Add your VCS repository to the new workspace that you created in  Terraform Enterprise
   - more on how to do this [here](https://www.terraform.io/docs/enterprise/vcs/index.html)

 - 


