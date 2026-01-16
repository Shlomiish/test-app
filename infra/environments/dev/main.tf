module "vpc" {
  source = "../../modules/network/vpc"

  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "logs" {
  source = "../../modules/observability/cloudwatch_logs"

  name              = var.name
  retention_in_days = var.log_retention_days
}


module "ecr" {
  source = "../../modules/compute/ecr"

  name         = var.name
  repositories = var.ecr_repositories

  image_tag_mutability = "IMMUTABLE"
  scan_on_push         = true
}
