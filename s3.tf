resource "aws_s3_bucket" "bucket" {
  bucket        = var.name
  force_destroy = false
  tags          = var.additional_tags
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Arq takes care of setting the objects to standard or deep archive depending on what is needed
# we only need to configure archival of noncurrent-versioned objects
resource "aws_s3_bucket_lifecycle_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    status = "Enabled"
    id     = "noncurrent_transition"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }

    noncurrent_version_transition {
      noncurrent_days = 7
      storage_class   = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      noncurrent_days = 187 # Minimum storage for Glacier Deep Archive is 180 + 7 for transition to GDA
    }
  }
}

# Enforce the bucket being private
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
