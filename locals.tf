# Global configurations for each AWS service
locals {
  vpc_config    = jsondecode(file("${path.module}/configs/vpc_config.json"))
  ec2_config    = jsondecode(file("${path.module}/configs/ec2_config.json"))
  iam_config    = jsondecode(file("${path.module}/configs/iam_config.json"))
  s3_config     = jsondecode(file("${path.module}/configs/s3_config.json"))
  sqs_config    = jsondecode(file("${path.module}/configs/sqs_config.json"))
  sns_config    = jsondecode(file("${path.module}/configs/sns_config.json"))
  lambda_config = jsondecode(file("${path.module}/configs/lambda_config.json"))
}

locals {
  online_store_web_app = {
    vpc : {
      security_group : local.vpc_config.security_groups["ec2_sg"].name
    }
    ec2 : {
      instance : local.ec2_config.machines["online_store_web_app"],
    },
    elb : {
      elb_name : "online-store-web-app-elb"
      security_group : local.vpc_config.security_groups["elb_sg"].name
    },
    s3 : {
      bucket : local.s3_config.buckets["online_store_web_app_ec2"]
    }
  }

  product_metadata_bucket = {
    iam : {
      roles : {
        editor : local.iam_config["product_metadata_bucket"]
      }
    },
    s3 : {
      bucket : local.s3_config.buckets["product_metadata_bucket"]
    }
  }

  order_storage_bucket = {
    iam : {
      roles : {
        provider : local.iam_config["orders_storage_bucket"]
      }
    },
    s3 : {
      bucket : local.s3_config.buckets["orders_storage_bucket"]
    }
  }

  institutional_page_website = {
    s3 : {
      bucket : local.s3_config.buckets["static_website_bucket"]
    }
  }

  order_processing = {
    iam : {
      roles : {
        enqueue : local.iam_config["order_processing_queue"]
        execute_lambda : local.iam_config["order_processing_lambda"]
      }
    }
    sqs : {
      queue : local.sqs_config["order_processing_queue"]
    }
    sns : {
      topic : local.sns_config["customer_notifications"]
    }
    sns_to_sqs : {
      protocol : "sqs"
    }
    lambda : {
      function : local.lambda_config["order_processing"]
    }
  }
}

