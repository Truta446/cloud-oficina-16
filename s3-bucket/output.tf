output "s3_log" {
  value = aws_s3_bucket.cf_logging_bucket.bucket
}