resource "aws_ecs_cluster" "packy-v2-ecs-cluster" {
    name = "packy-v2-cluster"
}

resource "aws_ecs_task_definition" "packy-v2-dev-api-task" {
    family = "packy-v2-dev-api-task"
    network_mode = "bridge"
    requires_compatibilities = [ "EC2" ]

    container_definitions = jsonencode([{
        name = "packy-v2-dev-api-server"
        image = "881490131558.dkr.ecr.ap-northeast-2.amazonaws.com/packy-v2-dev:latest"
        cpu = 256 # 0.25 vCPU
        memory = 384 # 384MB
        essential = true
        portMappings = [{
            containerPort = 80
            hostPort = 80
        }]
    }])
}

# resource "aws_ecs_service" "packy-v2-dev-api-service" {
#     name = "packy-v2-dev-api-service"
#     cluster = aws_ecs_cluster.packy-v2-ecs-cluster.id
#     task_definition = aws_ecs_task_definition.packy-v2-dev-api-task.arn
#     desired_count = 1

#     launch_type = "EC2"
#     depends_on = [ aws_instance.packy-v2-ecs-dev-ec2 ]
# }