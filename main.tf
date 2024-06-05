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
# Centralized logs for main resources
#--------------------------------------------------------------------
module "centralized_logs" {
  source = "./modules/cloudwatch"

  log_group_name    = local.logs.cloudwatch.central_log_group.group_name
  retention_in_days = local.logs.cloudwatch.central_log_group.retention_in_days
  tags              = local.logs.cloudwatch.central_log_group.tags
}

module "ec2_instances_logs_role" {
  source = "./modules/iam"

  role_name          = local.logs.iam.roles.ec2_receive_logs.role_name
  assume_role_policy = jsonencode(local.logs.iam.roles.ec2_receive_logs.assume_role_policy)
  arn                = module.centralized_logs.log_group_arn
  policies = [
    for policy in local.logs.iam.roles.ec2_receive_logs.policies : {
      policy_name     = policy.policy_name
      policy_template = jsonencode(policy.policy_template)
    }
  ]

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
  log_group_name    = module.centralized_logs.log_group_name
  user_data_path    = local.online_store_web_app.ec2.instance.user_data_path
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

module "product_metadata_bucket_iam_role" {
  source = "./modules/iam"

  role_name          = local.product_metadata_bucket.iam.roles.editor.role_name
  assume_role_policy = jsonencode(local.product_metadata_bucket.iam.roles.editor.assume_role_policy)
  arn                = module.product_metadata_bucket.bucket_arn
  policies = [
    for policy in local.product_metadata_bucket.iam.roles.editor.policies : {
      policy_name     = policy.policy_name
      policy_template = jsonencode(policy.policy_template)
    }
  ]

}

#--------------------------------------------------------------------
# Order Storage Bucket to be used by Providers to store orders
#--------------------------------------------------------------------
module "orders_storage_bucket" {
  source        = "./modules/s3"
  bucket_name   = local.order_storage_bucket.s3.bucket.name
  force_destroy = local.order_storage_bucket.s3.bucket.force_destroy
  tags          = local.order_storage_bucket.s3.bucket.tags
}

#--------------------------------------------------------------------
# Static Website for the institutional page
#--------------------------------------------------------------------
module "institutional_page_website" {
  source         = "./modules/s3"
  bucket_name    = local.institutional_page_website.s3.bucket.name
  force_destroy  = local.institutional_page_website.s3.bucket.force_destroy
  tags           = local.institutional_page_website.s3.bucket.tags
  enable_website = true
  index_document = local.institutional_page_website.s3.bucket.website.index_document
  error_document = local.institutional_page_website.s3.bucket.website.error_document
  index_html     = local.institutional_page_website.s3.bucket.website.index_html
  error_html     = local.institutional_page_website.s3.bucket.website.error_html
  styles_css     = local.institutional_page_website.s3.bucket.website.styles_css
}

#--------------------------------------------------------------------
# Automatic Order Processing and Customer notifications
#--------------------------------------------------------------------
module "order_processing_queue" {
  source                     = "./modules/sqs"
  queue_name                 = local.order_processing.sqs.queue.name
  visibility_timeout_seconds = local.order_processing.sqs.queue.visibility_timeout_seconds
  message_retention_seconds  = local.order_processing.sqs.queue.message_retention_seconds
  tags                       = local.order_processing.sqs.queue.tags

}

module "order_processing_queue_iam_role" {
  source = "./modules/iam"

  role_name          = local.order_processing.iam.roles.enqueue.role_name
  assume_role_policy = jsonencode(local.order_processing.iam.roles.enqueue.assume_role_policy)
  arn                = module.order_processing_queue.queue_arn
  policies = [
    for policy in local.order_processing.iam.roles.enqueue.policies : {
      policy_name     = policy.policy_name
      policy_template = jsonencode(policy.policy_template)
    }
  ]

}

module "order_processing_topic" {
  source = "./modules/sns"

  topic_name = local.order_processing.sns.topic.topic_name
  tags       = local.order_processing.sns.topic.tags
}

module "order_processing_notifications" {
  source = "./modules/sns_to_sqs"

  topic_arn = module.order_processing_topic.topic_arn
  protocol  = local.order_processing.sns_to_sqs.protocol
  endpoint  = module.order_processing_queue.queue_arn
}

module "order_processing_lambda_iam_role" {
  source = "./modules/iam"

  role_name          = local.order_processing.iam.roles.execute_lambda.role_name
  assume_role_policy = jsonencode(local.order_processing.iam.roles.execute_lambda.assume_role_policy)
  arn                = module.order_processing_queue.queue_arn
  policies = [
    for policy in local.order_processing.iam.roles.execute_lambda.policies : {
      policy_name     = policy.policy_name
      policy_template = jsonencode(policy.policy_template)
    }
  ]

}

module "order_processing_lambda" {
  source = "./modules/lambda"

  function_name  = local.order_processing.lambda.function.function_name
  handler        = local.order_processing.lambda.function.handler
  runtime        = local.order_processing.lambda.function.runtime
  filename       = local.order_processing.lambda.function.filename
  queue_url      = module.order_processing_queue.queue_url
  bucket         = module.orders_storage_bucket.bucket_id
  bucket_arn     = module.orders_storage_bucket.bucket_arn
  role_arn       = module.order_processing_lambda_iam_role.role_arn
  log_group_name = module.centralized_logs.log_group_name
}

