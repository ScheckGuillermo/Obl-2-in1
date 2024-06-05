resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
    }
  ]
}
POLICY

  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

resource "aws_s3_object" "index_html" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  key    = var.index_document
  source = var.index_html
  content_type = "text/html"

  depends_on = [aws_s3_bucket_policy.this, aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_object" "styles_css" {
  count  = var.enable_website ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  key    = "styles.css"
  source = var.styles_css
  content_type = "text/css"

  depends_on = [aws_s3_bucket_policy.this, aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_object" "error_html" {
  count        = var.enable_website ? 1 : 0
  bucket       = aws_s3_bucket.this.bucket
  key          = var.error_document
  source       = var.error_html
  content_type = "text/html"

  depends_on = [aws_s3_bucket_policy.this, aws_s3_bucket_public_access_block.this]
}
