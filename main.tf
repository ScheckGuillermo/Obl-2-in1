module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = local.vpc_config.vpc_cidr
  vpc_name             = local.vpc_config.vpc_name
  public_subnet_cidrs  = local.vpc_config.public_subnet_cidrs
  private_subnet_cidrs = local.vpc_config.private_subnet_cidrs
  availability_zones   = local.vpc_config.availability_zones
  security_groups      = local.vpc_config.security_groups
}

module "s3" {
  source        = "./modules/s3"
  bucket_name   = "online-store-web-app"
  force_destroy = true
  tags          = {}
}

module "ec2" {
  source = "./modules/ec2"

  ami_id            = local.online_store_web_app_machine.ami_id
  instance_type     = local.online_store_web_app_machine.instance_type
  machine_name      = local.online_store_web_app_machine.name
  instance_count    = local.online_store_web_app_machine.instance_count
  instance_tags     = local.online_store_web_app_machine.instance_tags
  subnet_id         = module.vpc.private_subnet_ids[0]
  security_group_id = module.vpc.security_group_ids[local.online_store_web_app_machine_sg]
  ssh_key_bucket    = module.s3.bucket_id
}

module "elb" {
  source = "./modules/elb"

  elb_name          = "online-store-elb"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.vpc.security_group_ids[local.elb_sg]
  machine_ids      = module.ec2.machine_ids

}
