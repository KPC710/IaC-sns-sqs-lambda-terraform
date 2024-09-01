resource "aws_s3_bucket" "lambda_logs_bucket" {
  bucket = "lambda-logs-bucket-${substr(md5(timestamp()), 0, 8)}"
}

# Create SNS Topic
resource "aws_sns_topic" "sns_topic" {
  name = var.sns_topic_name
}

# Create SQS Queue
resource "aws_sqs_queue" "sqs_queue" {
  name = var.sqs_queue_name
}

# Create SNS Subscription to SQS Queue
resource "aws_sns_topic_subscription" "sns_sqs_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs_queue.arn

  filter_policy_scope = "MessageBody"

  filter_policy = jsonencode({
    "eventType" = ["order_created", "order_shipped"]
  })

}

# Allow SNS to send messages to SQS
resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.sqs_queue.url

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sns.amazonaws.com"
        },
        Action   = "sqs:SendMessage",
        Resource = aws_sqs_queue.sqs_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.sns_topic.arn
          }
        }
      }
    ]
  })
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "${var.lambda_function_name}-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to allow Lambda to interact with AWS services
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatch_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Create Lambda Function
resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_exec.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  # Path to your Lambda function code
  filename = "lambda/lambda_function.zip"

  #   source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN   = aws_sns_topic.sns_topic.arn
      LOG_BUCKET_NAME = aws_s3_bucket.lambda_logs_bucket.bucket
    }
  }
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
  retention_in_days = var.log_group_retention_in_days
}


# IAM Policy for Lambda to access SQS
resource "aws_iam_policy" "lambda_sqs_policy" {
  name        = "lambda-sqs-policy"
  description = "Policy to allow Lambda to access SQS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueAttributes"  # Added this permission
        ],
        Resource = aws_sqs_queue.sqs_queue.arn
      }
    ]
  })
}

# Attach the policy to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_sqs_policy_attachment" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}


# Create Lambda Event Source Mapping
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.sqs_queue.arn
  function_name    = aws_lambda_function.lambda_function.arn
  batch_size       = var.lambda_batch_size
  enabled          = true
}
