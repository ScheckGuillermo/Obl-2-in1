locals {
  flattened_instance_ids = flatten([
    for machine_name, ids in var.machine_ids : [
      for id in ids : {
        machine_name = machine_name
        instance_id  = id
      }
    ]
  ])
}
