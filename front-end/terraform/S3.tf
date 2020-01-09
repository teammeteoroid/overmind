
provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-2"

}
resource "aws_s3_bucket" "static_hosting" {
  bucket = "www.test-overmind.com"
  website {
    index_document = "index.html"
  }
}
resource "aws_s3_bucket_policy" "site" {
  bucket = "${aws_s3_bucket.static_hosting.id}"
  policy = "${data.aws_iam_policy_document.site_public_access.json}"
}

data "aws_iam_policy_document" "site_public_access" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_hosting.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.static_hosting.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
resource "aws_s3_bucket_object" "object" {
  bucket       = "${aws_s3_bucket.static_hosting.id}"
  key          = "build"
  source       = "../build"
  //content_type = "text/html"
}
