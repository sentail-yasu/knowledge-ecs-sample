terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "tfstate-bucket"　←自分用のS3バケットを作成して変更
    region  = "ap-northeast-1"
    key     = "dev/terraform.tfstate" ←任意で変更
    encrypt = true
  }
}
