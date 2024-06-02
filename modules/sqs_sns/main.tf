resource "aws_sqs_queue" "order_processing_queue" {
  name                       = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds
  tags                       = var.queue_tags
}

resource "aws_sns_topic" "customer_notifications_topic" {
  name = var.topic_name
  tags = var.topic_tags
}

resource "aws_sns_topic_subscription" "order_notifications_to_sqs" {
  topic_arn = aws_sns_topic.customer_notifications_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.order_processing_queue.arn
}

