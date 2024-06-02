output "queue_url" {
  value = aws_sqs_queue.order_processing_queue.id
}

output "queue_arn" {
  value = aws_sqs_queue.order_processing_queue.arn
}

output "topic_arn" {
  value = aws_sns_topic.customer_notifications_topic.arn
}
