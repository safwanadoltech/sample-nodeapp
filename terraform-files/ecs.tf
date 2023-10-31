provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_policy_attachment" "attach_policy_example" {
  name       = "PullImageFromECR"
  roles      = [aws_iam_role.ecs_execution_role.name]
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_ecs_cluster" "my_cluster" {
name="my-ecs-cluster"
}

resource "aws_ecs_task_definition" "my_task" {
family="my-app"
network_mode="awsvpc"
requires_compatibilities=["FARGATE"]
cpu="256"
memory="512"
task_role_arn=aws_iam_role.ecs_execution_role.arn
execution_role_arn=aws_iam_role.ecs_execution_role.arn
container_definitions= jsonencode([
    {
     name="my-app-container"
image="676213613849.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest" # your ecr repository URI found in aws management console
portMappings= [
{
containerPort=3000
hostPort=3000
}
]
}
])
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "PullImagesFromECR"
  description = "For ECS tasks to pull image from ECR"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
})
}
  
  
resource "aws_iam_role" "ecs_execution_role" {
name= "ecs_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_ecs_service" "my_service"{
name="my-app-service"
cluster= aws_ecs_cluster.my_cluster.id
task_definition= aws_ecs_task_definition.my_task.arn
desired_count = 1
launch_type= "FARGATE"

  
network_configuration {
security_groups=aws_security_group.ecs_task.arn
subnets= [tolist(module.vpc.public_subnets)[0],tolist(module.vpc.public_subnets)[1]]
assign_public_ip = true
}
depends_on= [aws_ecs_task_definition.my_task]
  load_balancer {
    container_name = "my-app-container"
    container_port = 3000
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

resource "aws_lb" "my_lb" {
name="my-app-lb"
internal = false
load_balancer_type="application"
subnets= [tolist(module.vpc.public_subnets)[0],tolist(module.vpc.public_subnets)[1]]
}

resource "aws_lb_target_group" "my_target_group" {
name="my-app-tg"
port=3000
protocol="HTTP"
  target_type = "ip"
vpc_id=module.vpc.vpc_id

}

resource "aws_lb_listener" "my_listener" {
load_balancer_arn=aws_lb.my_lb.arn
port=80
protocol="HTTP"
default_action {
type="forward"
target_group_arn=aws_lb_target_group.my_target_group.arn
}
}

#data "aws_ecr_image" "my-ecr-repo" {
#  repository_name = "my-ecr-repo"
#  image_tag = "latest"
#
#}@${data.aws_ecr_image.my-ecr-repo.image_digest}

