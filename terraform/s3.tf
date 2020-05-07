# プライベートバケットの定義
resource "aws_s3_bucket" "alb-logs" {
  # バケット名は世界で1意にしなければならない
  bucket = "${var.name}-alb-logs-01"　←自分の環境用に変更してください

  versioning {
    enabled = true
  }

  # 暗号化を有効
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# ブロックパブリックアクセス
resource "aws_s3_bucket_public_access_block" "alb-logs" {
  bucket                  = aws_s3_bucket.alb-logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
