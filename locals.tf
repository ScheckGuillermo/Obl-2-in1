locals {
  network_config = jsondecode(file("${path.module}/configs/network_config.json"))
  ec2_config     = jsondecode(file("${path.module}/configs/ec2_config.json"))
}

locals {
  web_app_instance_sg = local.network_config.security_groups["ec2_sg"].name
}
