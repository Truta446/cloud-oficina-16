resource "aws_s3_bucket" "cf_logging_bucket" {
  bucket        = var.cf_logging_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "cf_logging_bucket" {
  bucket                  = aws_s3_bucket.cf_logging_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cf_logging_bucket" {
  bucket = aws_s3_bucket.cf_logging_bucket.id
  rule {
    # control_object_ownership = true
    object_ownership = "BucketOwnerPreferred"

  }
}

data "aws_iam_policy_document" "cf_logging_bucket" {
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
    ]

    resources = [
      aws_s3_bucket.cf_logging_bucket.arn,
      "${aws_s3_bucket.cf_logging_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_object" "prefix" {
  bucket       = aws_s3_bucket.cf_logging_bucket.id
  acl          = "private"
  key          = "${var.prefix}/"
  content_type = "application/x-directory"
}