# Amazon EKS Node Group with Launch Template Terraform module

Terraform module which creates EKS Node Group with Launch Template resources on AWS.

These types of resources are supported:

* [EKS Node Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
* [IAM Role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
* [IAM Role Policy Attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)
* [IAM Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)


## Usage
### Amazon EKS Node Group with Launch Template

main.tf
```hcl
module "eks_worker_nodes_with_lt" {
  source = "git@github.com:jangjaelee/terraform-aws-eks-workernodes-with-lt.git"

  vpc_name        = local.vpc_name
  cluster_name    = local.cluster_name
  key_name        = local.vpc_name  
  node_group_name = "${local.cluster_name}_Worker_Nodes_Group_1"
  lt_name         = "${local.cluster_name}-CentOS-7_AMI"
  lt_version      = 1
  
  scaling_desired_size = 4
  scaling_min_size     = 4
  scaling_max_size     = 8

  env = "dev"
}
```

locals.tf
```hcl
locals {
  vpc_name = "KubeSphere-dev"
  cluster_name = "KubeSphere-v121-dev"
  cluster_version = "1.21"
}
```

providers.tf
```hcl
provider "aws" {
  version = ">= 3.2.0"
  region = var.region
  allowed_account_ids = var.account_id
  profile = "eks_service"
}
```

terraform.tf
```hcl
terraform {
  required_version = ">= 0.13.0"

  backend "s3" {
    bucket = "kubesphere-terraform-state-backend"
    key = "kubesphere/eks-worknode-with-lt/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "dev-env-terraform-state-locks"
    encrypt = true
    profile = "eks_service"
  }
}
```

variables.tf
```hcl
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

variable "account_id" {
  description = "List of Allowed AWS account IDs"
  type        = list(string)
  default     = ["123456789012"]
}
```
