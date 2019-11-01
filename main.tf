resource "aws_s3_account_public_access_block" "global_block" {
  block_public_acls   = true
  block_public_policy = true
}
resource "aws_s3_bucket" "bucket-1" {
  bucket = "sentinel-demo-bucket-1"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = "${aws_s3_bucket.bucket-1.id}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNonSecureTraffic",
      "Action": "s3:*",
      "Effect": "Deny",
      "Principal":  "*",
      "Resource": [ 
        "arn:aws:s3:::${aws_s3_bucket.bucket-1.bucket}/*",
        "arn:aws:s3:::${aws_s3_bucket.bucket-1.bucket}" 
      ],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      }
    }
  ]
}
POLICY
}