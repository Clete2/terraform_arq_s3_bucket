A simple Terraform module that creates a S3 bucket for use with Arq Backup.

# Inputs
* `name` -> S3 bucket name
* `additional_tags` -> `map(string)` to apply additional tags to the S3 bucket in addition to the ones created by the AWS provider's `default_tags` argument

# Outputs
* `bucket_id` -> S3 bucket name
* `bucket_arn` -> Full ARN for bucket