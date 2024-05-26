resource "tls_private_key" "key_gen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_s3_object" "private_key" {
  bucket  = var.ssh_key_bucket
  key     = "${var.instance_name}.pem"
  content = tls_private_key.key_gen.private_key_openssh
}

resource "aws_key_pair" "key" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.key_gen.public_key_openssh
}


resource "aws_instance" "ec2" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  ipv6_address_count     = var.enable_ipv6 ? 1 : 0
  key_name               = aws_key_pair.key.key_name


  tags = merge(
    {
      Name = "${var.instance_name}_${count.index + 1}"
    },
    var.instance_tags
  )

}
