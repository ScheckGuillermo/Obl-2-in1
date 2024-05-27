module "network" {
  source = "./modules/network"

  vpc_cidr             = local.network_config.vpc_cidr
  vpc_name             = local.network_config.vpc_name
  public_subnet_cidrs  = local.network_config.public_subnet_cidrs
  private_subnet_cidrs = local.network_config.private_subnet_cidrs
  availability_zones   = local.network_config.availability_zones
  security_groups      = local.network_config.security_groups
}

module "s3" {
  source        = "./modules/s3"
  bucket_name   = "online-store-web-app"
  force_destroy = true
}

module "ec2" {
  for_each = { for instance in local.ec2_config.instances : instance.instance_name => instance }
  source   = "./modules/ec2"

  ami_id            = each.value.ami_id
  instance_type     = each.value.instance_type
  instance_name     = each.value.instance_name
  instance_count    = each.value.instance_count
  instance_tags     = each.value.instance_tags
  subnet_id         = module.network.private_subnet_ids[0]
  security_group_id = module.network.security_group_ids[local.web_app_instance_sg]
  ssh_key_bucket    = module.s3.bucket
  enable_ipv6       = false

}

module "elb" {
  source = "./modules/elb"

  elb_name          = "online-store-elb"
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.network.security_group_ids[local.elb_sg]
  instance_ids      = flatten([for instance in module.ec2 : instance.instance_ids])

}
