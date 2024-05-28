output "machine_ids" {
  description = "IDs of the created EC2 instances"
  value = {
    (var.machine_name) = [
      for instance in aws_instance.ec2 : instance.id
    ]
  }
}

