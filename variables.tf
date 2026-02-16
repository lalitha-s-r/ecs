variable "region" {}
variable "cluster_name" {}
variable "task_family" {}
variable "container_name" {}
variable "container_protocol" {}
variable "container_port" {}

variable "execution_role_arn" {}
variable "task_role_arn" {}

variable "ecr_repo_name" {}

variable "vpc_cidr" {}

variable "public_cidr_1" {}
variable "public_cidr_2" {}

variable "private_cidr_1" {}
variable "private_cidr_2" {}

variable "az_1" {}
variable "az_2" {}
