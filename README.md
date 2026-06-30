# terraform-aws-instance

Terraform module that provisions an AWS EC2 instance using a pre-built Redhat 9 Practice AMI. The instance is tagged automatically with project, environment, and component metadata so resources are consistently labelled across your infrastructure.

## Usage

module "ec2" {
source = "github.com/sai-pillalamarri/terraform-aws-instance"

project = "roboshop"
environment = "dev"
component = "backend"
sg_ids = ["sg-0abc123def456"]
}

### With optional overrides

module "ec2" {
source = "github.com/sai-pillalamarri/terraform-aws-instance"

project = "roboshop"
environment = "prod"
component = "frontend"
instance_type = "t3.small"
sg_ids = ["sg-0abc123def456", "sg-0def789abc012"]

ec2_tags = {
Owner = "sai"
CostCenter = "cc-1234"
}
}

## Resources

| Resource            | Description                                         |
| ------------------- | --------------------------------------------------- |
| `aws_instance.main` | EC2 instance created from the Redhat 9 Practice AMI |

## AMI

The module automatically fetches the most recent AMI matching:

| Filter         | Value                    |
| -------------- | ------------------------ |
| Name pattern   | Redhat-9-DevOps-Practice |
| Owner account  | 973714476881             |
| Root device    | ebs                      |
| Virtualisation | hvm                      |
| Architecture   | x86_64                   |

## Inputs

| Name          | Type         | Required | Default  | Description                                                                                                   |
| ------------- | ------------ | :------: | -------- | ------------------------------------------------------------------------------------------------------------- |
| project       | string       |   Yes    | —        | Project name (e.g. roboshop). Used in the instance Name tag and common tags.                                  |
| environment   | string       |   Yes    | —        | Deployment environment (e.g. dev, staging, prod). Used in the instance Name tag and common tags.              |
| component     | string       |   Yes    | —        | Component or service name (e.g. frontend, backend, catalogue). Used in the instance Name tag and common tags. |
| sg_ids        | list(string) |   Yes    | —        | List of Security Group IDs to attach to the instance.                                                         |
| instance_type | string       |    No    | t3.micro | EC2 instance type. Allowed values: t3.micro, t3.small.                                                        |
| ec2_tags      | map(any)     |    No    | {}       | Additional tags to merge onto the instance (e.g. Owner, CostCenter).                                          |

## Tagging behaviour

Every instance receives a merged tag set built from three sources:

1. `ec2_tags` — any extra tags you pass in.
2. Common tags — `Project`, `Environment`, `Component` derived from the required variables.
3. `Name` — automatically set to `<project>-<environment>-<component>`.

Later sources override earlier ones on key collision.

## Outputs

| Name       | Description                                 |
| ---------- | ------------------------------------------- |
| public_ip  | Public IP address of the created instance.  |
| private_ip | Private IP address of the created instance. |

## Requirements

| Requirement     | Version                                                        |
| --------------- | -------------------------------------------------------------- |
| Terraform       | >= 1.5                                                         |
| AWS provider    | ~> 6.0                                                         |
| AWS credentials | Must have `ec2:RunInstances`, `ec2:DescribeImages` permissions |

## Notes

- This module does not create security groups — pass existing security group IDs via `sg_ids`.
- Provider and backend configuration are managed by the calling (root) module, not inside this module.
- One module call provisions one instance — for multiple services, call the module once per component.
