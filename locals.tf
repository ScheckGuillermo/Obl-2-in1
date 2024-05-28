locals {
  vpc_config = jsondecode(file("${path.module}/configs/vpc_config.json"))
  ec2_config = jsondecode(file("${path.module}/configs/ec2_config.json"))
}

locals {
  online_store_web_app_machine_sg = local.vpc_config.security_groups["ec2_sg"].name
  elb_sg                       = local.vpc_config.security_groups["elb_sg"].name
}

locals {
  online_store_web_app_machine = local.ec2_config.machines["online-store-web-app"]
}
