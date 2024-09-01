# AWS Region
variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

# S3 Bucket Name for Lambda Logs
variable "s3_bucket_name" {
  description = "The name of the S3 bucket to store Lambda logs."
  type        = string
  default     = "lambda-logs-bucket"
}

# SNS Topic Name
variable "sns_topic_name" {
  description = "The name of the SNS topic."
  type        = string
  default     = "sns-topic"
}

# SQS Queue Name
variable "sqs_queue_name" {
  description = "The name of the SQS queue."
  type        = string
  default     = "sqs-queue"
}

# Lambda Function Name
variable "lambda_function_name" {
  description = "The name of the Lambda function."
  type        = string
  default     = "lambda-function"
}

# Lambda Runtime
variable "lambda_runtime" {
  description = "The runtime for the Lambda function."
  type        = string
  default     = "python3.8"
}

# Lambda Handler
variable "lambda_handler" {
  description = "The handler for the Lambda function."
  type        = string
  default     = "lambda_function.lambda_handler"
}

# Lambda Log Group Retention in Days
variable "log_group_retention_in_days" {
  description = "The number of days to retain logs in CloudWatch."
  type        = number
  default     = 14
}

# Lambda Batch Size for SQS Trigger
variable "lambda_batch_size" {
  description = "The batch size for SQS messages triggering the Lambda function."
  type        = number
  default     = 10
}
