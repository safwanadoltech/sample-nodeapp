resource "aws_ecr_repository" "my-ecr-repo" {
name = "my-ecr-repo"                         #replace with the desired name
image_tag_mutability = "MUTABLE"
}
