cluster_name        = "fargate-example"
task_family         = "fargate-ecs"

execution_role_arn  = "arn:aws:iam::227224898353:role/dev-ecstaskexecution"
task_role_arn       = "arn:aws:iam::227224898353:role/dev-ecs-task-role-with-observability"

container_name      = "fargate1"
container_protocol  = "tcp"
container_port      = 8080

ecr_repo_name       = "ecs-fargate"

region = "us-east-1"
vpc_cidr       = "10.0.0.0/16"

public_cidr_1  = "10.0.10.0/24"
public_cidr_2  = "10.0.20.0/24"

private_cidr_1 = "10.0.30.0/24"
private_cidr_2 = "10.0.40.0/24"


az_1 = "us-east-1a"
az_2 = "us-east-1b"

