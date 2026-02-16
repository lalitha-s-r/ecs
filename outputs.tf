output "alb_dns" {
  value = module.alb.alb_dns_name
}

output "ecs_service_name" {
  value = module.ecs_fargate_task.service_name
}
