# Output the ARN of the SNS Topic
output "sns_topic_arn" {
  description = "The ARN of the SNS Topic"
  value       = aws_sns_topic.sns_topic.arn
}

# Output the URL of the SQS Queue
output "sqs_queue_url" {
  description = "The URL of the SQS Queue"
  value       = aws_sqs_queue.sqs_queue.url
}

# Output the ARN of the SQS Queue
output "sqs_queue_arn" {
  description = "The ARN of the SQS Queue"
  value       = aws_sqs_queue.sqs_queue.arn
}

# Output the ARN of the Lambda Function
output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_lambda_function.lambda_function.arn
}

# Output the Name of the S3 Bucket for Lambda Logs
output "s3_bucket_name" {
  description = "The name of the S3 Bucket for Lambda logs"
  value       = aws_s3_bucket.lambda_logs_bucket.bucket
}

# Output the CloudWatch Log Group Name for Lambda
output "lambda_log_group_name" {
  description = "The name of the CloudWatch Log Group for the Lambda function"
  value       = aws_cloudwatch_log_group.lambda_log_group.name
}
