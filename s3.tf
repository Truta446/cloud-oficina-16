resource "aws_s3_bucket" "documents" {
  bucket = "${var.client}-dev"

  tags = var.tags
}