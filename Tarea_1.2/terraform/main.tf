resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment        = "Production"
    ProjectName        = var.project_name
    DataClassification = "PII"
    Owner              = var.owner
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.secure_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.secure_bucket.id

  rule {
    id     = "expire-noncurrent-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  count = length(var.allowed_source_ips) > 0 ? 1 : 0

  statement {
    sid     = "DenyRequestsNotFromApprovedIPs"
    effect  = "Deny"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.secure_bucket.arn,
      "${aws_s3_bucket.secure_bucket.arn}/*"
    ]

    condition {
      test     = "NotIpAddress"
      variable = "aws:SourceIp"
      values   = var.allowed_source_ips
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = length(var.allowed_source_ips) > 0 ? 1 : 0
  bucket = aws_s3_bucket.secure_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy[0].json
}
