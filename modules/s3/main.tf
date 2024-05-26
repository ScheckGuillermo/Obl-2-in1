resource "aws_s3_bucket" "ssh_key_bucket" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
}
