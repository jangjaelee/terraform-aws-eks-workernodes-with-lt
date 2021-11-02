variable "vpc_name" {
  description = "Name to be used on all the resources as identifier for VPC"
  type = string
}

variable "cluster_name" {
  description = "Name for EKS Cluster"
  type = string
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type = string
}

variable "lt_name" {
  description = "choose your own launch template name for Cluster nodes"
  type = string
}

variable "lt_version" {
  description = "version of launch template"
  type = number
}
variable "scaling_desired_size" {
  description = "Desired size of worker nodes for auto scaling"
  type = number
}

variable "scaling_min_size" {
  description = "Min size of worker nodes for auto scaling"
  type = number
}

variable "scaling_max_size" {
  description = "Max size of worker nodes for auto scaling"
  type = number
}

variable "key_name" {
  description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group."
  type = string
}

variable "env" {
  description = "Environment"
  type = string
}