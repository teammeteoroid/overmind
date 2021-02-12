
provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-2"
}
resource "aws_s3_bucket" "static_hosting" {
  bucket = "www.overmind.com"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
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
variable "upload_directory" {
  default = "../build/"
}
variable "mime_types" {
  default = {
    js      = "application/javascript"
    map     = "application/javascript"
    json    = "application/json"
    eot     = "application/vnd.ms-fontobject"
    png     = "image/png"
    svg     = "image/svg+xml"
    ttf     = "application/octet-stream"
    woff    = "application/font-woff"
    woff2   = "application/font-woff"
    ico     = "image/x-icon"
    css     = "text/css"
    html    = "text/html"
    txt     = "text/plain"
    LICENSE = "text/plain"
  }
}
resource "aws_s3_bucket_object" "object" {
  bucket = "${aws_s3_bucket.static_hosting.id}"
  #   key          = "build"
  #   source       = "../build"
  //content_type = "text/html"

  for_each = fileset(var.upload_directory, "**/*.*")
  #   bucket        = aws_s3_bucket.s3_static.bucket
  key          = replace(each.value, var.upload_directory, "")
  source       = "${var.upload_directory}${each.value}"
  acl          = "public-read"
  etag         = filemd5("${var.upload_directory}${each.value}")
  content_type = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
  //content_type = "text/html"
}
