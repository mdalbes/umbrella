resource "aws_s3_bucket" "tfstate_bucket" {
  bucket = var.tfstate_bucket_name
  force_destroy = var.force_destroy

}


resource "aws_s3_bucket" "tfstate_bucket_log_bucket" {
  bucket = var.tfstate_bucket_name
}


resource "aws_s3_bucket_versioning" "tfstate_bucket_log_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket_log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_logging" "tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  target_bucket = aws_s3_bucket.tfstate_bucket_log_bucket.id
  target_prefix = "log/"
}




resource "aws_s3_bucket_versioning" "versioning_tfstate_bucket" {
  bucket = aws_s3_bucket.tfstate_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.tfstate_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
    }
  }
}


resource "aws_s3_bucket_public_access_block" "default" {
  bucket                  = aws_s3_bucket.tfstate_bucket.id
  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_dynamodb_table" "with_server_side_encryption" {
  name           = var.dynamodb_name
  point_in_time_recovery {
   enabled = true
  }
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "LockID"

  server_side_encryption {
    enabled = var.dynamo_db_encryption
  }

  lifecycle {
    ignore_changes = [read_capacity, write_capacity]
  }

  attribute {
    name = "LockID"
    type = "S"
  }

}
