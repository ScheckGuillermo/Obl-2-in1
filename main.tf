#--------------------------------------------------------------------
# Main VPC where all the resources will be created
#--------------------------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = local.vpc_config.vpc_cidr
  vpc_name             = local.vpc_config.vpc_name
  public_subnet_cidrs  = local.vpc_config.public_subnet_cidrs
  private_subnet_cidrs = local.vpc_config.private_subnet_cidrs
  availability_zones   = local.vpc_config.availability_zones
  security_groups      = local.vpc_config.security_groups
}

#--------------------------------------------------------------------
# Online Store Web App
#--------------------------------------------------------------------
module "online_store_ec2_instances" {
  source = "./modules/ec2"

  ami_id            = local.online_store_web_app.ec2.instance.ami_id
  instance_type     = local.online_store_web_app.ec2.instance.instance_type
  machine_name      = local.online_store_web_app.ec2.instance.name
  instance_count    = local.online_store_web_app.ec2.instance.instance_count
  instance_tags     = local.online_store_web_app.ec2.instance.instance_tags
  subnet_id         = module.vpc.private_subnet_ids[0]
  security_group_id = module.vpc.security_group_ids[local.online_store_web_app.vpc.security_group]
  ssh_key_bucket    = module.product_metadata_bucket.bucket_id
}

module "online_store_elb" {
  source = "./modules/elb"

  elb_name          = local.online_store_web_app.elb.elb_name
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.vpc.security_group_ids[local.online_store_web_app.elb.security_group]
  machine_ids       = module.online_store_ec2_instances.machine_ids

}

#--------------------------------------------------------------------
# Product metadata bucket for storing product images and other metadata
#--------------------------------------------------------------------
module "product_metadata_bucket" {
  source        = "./modules/s3"
  bucket_name   = local.product_metadata_bucket.s3.bucket.name
  force_destroy = local.product_metadata_bucket.s3.bucket.force_destroy
  tags          = local.product_metadata_bucket.s3.bucket.tags
}

module "product_metadata_bucket_roles_and_policies" {
  source = "./modules/iam"

  role_name          = local.product_metadata_bucket.iam.roles_and_policies.role_name
  assume_role_policy = jsonencode(local.product_metadata_bucket.iam.roles_and_policies.assume_role_policy)
  arn                = module.product_metadata_bucket.bucket_arn
  policies = [
    for policy in local.product_metadata_bucket.iam.roles_and_policies.policies : {
      policy_name     = policy.policy_name
      policy_template = jsonencode(policy.policy_template)
    }
  ]

}

#--------------------------------------------------------------------
# Provider's bucket for storing products
#--------------------------------------------------------------------
module "product_storage_bucket" {
  source        = "./modules/s3"
  bucket_name   = local.product_storage_bucket.s3.bucket.name
  force_destroy = local.product_storage_bucket.s3.bucket.force_destroy
  tags          = local.product_storage_bucket.s3.bucket.tags
}

#--------------------------------------------------------------------
# Static Website Bucket for the institutional page
#--------------------------------------------------------------------
module "institutional_page_website" {
  source         = "./modules/s3"
  bucket_name    = local.institutional_page_website.s3.bucket.name
  force_destroy  = local.institutional_page_website.s3.bucket.force_destroy
  tags           = local.institutional_page_website.s3.bucket.tags
  enable_website = true
  index_document = local.institutional_page_website.s3.bucket.website.index_document
  error_document = local.institutional_page_website.s3.bucket.website.error_document
}
