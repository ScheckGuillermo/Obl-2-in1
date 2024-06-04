resource "tls_private_key" "key_gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_s3_object" "private_key" {
  bucket  = var.ssh_key_bucket
  key     = "${var.machine_name}.pem"
  content = tls_private_key.key_gen.private_key_openssh
}

resource "aws_key_pair" "key" {
  key_name   = "${var.machine_name}-key"
  public_key = tls_private_key.key_gen.public_key_openssh
}

data "template_file" "user_data_script" {
  template = file(var.user_data_path)
  count    = var.instance_count

  vars = {
    log_group_name = var.log_group_name
    instance_index = "${count.index}"
  }
}

resource "aws_instance" "ec2" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.key.key_name
  user_data              = data.template_file.user_data_script[count.index].rendered


  tags = merge(
    {
      Name = "${var.machine_name}_${count.index + 1}"
    },
    var.instance_tags
  )

}
