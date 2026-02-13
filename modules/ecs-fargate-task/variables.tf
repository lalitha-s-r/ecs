variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "task_family" {
  description = "Task definition family name"
  type        = string
}

variable "cpu" {
  description = "Task CPU units"
  type        = number
  default     = 512
}

variable "memory" {
  description = "Task memory (MB)"
  type        = number
  default     = 4096
}

variable "execution_role" {
  description = "IAM execution role ARN for ECS task execution"
  type        = string
}

variable "task_role" {
  description = "IAM task role ARN"
  type        = string
}

variable "enable_service" {
  description = "Whether to create ECS service"
  type        = bool
  default     = false
}

variable "desired_count" {
  description = "Initial number of tasks"
  type        = number
  default     = 1
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "containerPort" {
  description = "Container port"
  type        = number
}

variable "container_protocol" {
  description = "Container protocol"
  type        = string
}

variable "container_image" {
  description = "Container image URI"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ECS service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ECS tasks"
  type        = string
}
