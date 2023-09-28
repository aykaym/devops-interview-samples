provider "aws" {
  region = "us-east-1"
}

module "vpc" {
    source = "./vpc"

}

module "ecs" {
  source = "./ecs"

  vpc_id = module.vpc.vpc_id
  alb_target_group_arn = module.alb.target_group_arn
}

module "alb" {
  source = "./alb"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  ecs_sg_id = module.autoscaling.ecs_instances_sg_id
}

module "autoscaling" {
  source = "./autoscaling"

  vpc_id = module.vpc.vpc_id
  alb_security_group_id = module.alb.alb_sg_id
}
