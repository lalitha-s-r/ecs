resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
resource "aws_cloudwatch_log_group" "ecs" {
  name = "/ecs/${var.task_family}"
  retention_in_days = 7
}
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role
  task_role_arn            = var.task_role # Required for X-Ray/CloudWatch write access
  depends_on = [aws_cloudwatch_log_group.ecs]
  container_definitions = templatefile("${path.module}/task_container_def.json", {
    container_image    = var.container_image
    container_name     = "fargate-1"
    containerPort      = 8080
    container_protocol = "http"
    log_group          = "/ecs/${var.task_family}"
    region             = var.region
  })
}


resource "aws_ecs_service" "this" {
  count           = var.enable_service ? 1 : 0
  name            = "${var.task_family}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count

  lifecycle {
    ignore_changes = [desired_count]
  }

  force_new_deployment = true

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "fargate-1"
    container_port   = 8080
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
    base              = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 4
  }

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = false
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  count = var.enable_service ? 1 : 0

  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.this]
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  count = var.enable_service ? 1 : 0

  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 50.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
  }
}
