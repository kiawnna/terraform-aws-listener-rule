resource "aws_lb_listener_rule" "app_listener_rule" {
  listener_arn = var.listener_arn
  priority     = random_integer.priority.result

  lifecycle {
    create_before_destroy = true
  }

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    host_header {
      values = [var.domain, "www.${var.domain}"]
    }
  }
}

resource "random_integer" "priority" {
  min     = 1
  max     = 49999
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    listener_arn = var.listener_arn
  }
}