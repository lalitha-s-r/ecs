provider "aws" {
  region  = "us-east-1"
  profile = "scratch-developer"
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repo_name
}


module "vpc" {
  source = "./modules/vpc"

  cidr         = var.vpc_cidr
  public_cidr  = var.public_cidr
  private_cidr = var.private_cidr
  az           = var.az
  vpc_name     = "fargate-vpc"
}


module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = [module.vpc.public_subnet_id]
  container_port    = var.container_port
  alb_name          = var.cluster_name
}



module "ecs_fargate_task" {
  source = "./modules/ecs-fargate-task"

  cluster_name   = var.cluster_name
  task_family    = var.task_family
  execution_role = var.execution_role_arn
  task_role      = var.task_role_arn

  enable_service = true
  desired_count  = 1

  container_image    = "${module.ecr.repository_url}:latest"
  container_name     = var.container_name
  containerPort      = var.container_port
  container_protocol = var.container_protocol

  # REQUIRED NETWORK + ALB WIRING
  target_group_arn  = module.alb.target_group_arn
  subnet_ids        = [module.vpc.private_subnet_id]
  security_group_id = module.alb.ecs_security_group_id

  region = var.region
}
