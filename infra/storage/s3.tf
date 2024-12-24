
# s3 bucket for frontend
resource "aws_s3_bucket" "app_s3_bucket" {
  bucket        = var.frontend_bucket_name
  force_destroy = true
  tags = {
    Name = var.frontend_bucket_name
  }
}

resource "aws_s3_bucket_ownership_controls" "app_s3_bucket" {
  bucket = aws_s3_bucket.app_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "app_public_access_block" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_acl" "app_s3_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.app_s3_bucket,aws_s3_bucket_public_access_block.app_public_access_block]

  bucket = aws_s3_bucket.app_s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "app_bucket_policy" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.app_s3_bucket.id}/*"
    }
  ]
}
POLICY

depends_on = [
  aws_s3_bucket_public_access_block.app_public_access_block,
]
}

resource "aws_s3_bucket_website_configuration" "app_s3_website" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_cors_configuration" "app_cors" {
  bucket = aws_s3_bucket.app_s3_bucket.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
  }
}

