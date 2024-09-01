## Architecture

The setup includes:

- **SNS Topic**: Simple Notification Service (SNS) topic where messages are initially sent.
- **SQS Queue**: Simple Queue Service (SQS) queue that receives messages from the SNS topic.
- **Lambda Function**: AWS Lambda function that processes messages from the SQS queue.# 
