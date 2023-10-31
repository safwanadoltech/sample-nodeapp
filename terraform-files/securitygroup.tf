resource "aws_security_group" "ecs_tasks" {
  name = "ecs-tasks-security-group"
  description = "allow inbound and outbound access from ecs to internet"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol = "tcp"
    from_port = 3000        #your app's port number
    to_port = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 80        #your app's port number
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 443        #your app's port number
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
