locals {
  ami_id = data.aws_ami.roboshop_base.id
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Component   = var.component
  }
}
