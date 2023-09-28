resource "aws_ecs_cluster" "example-ecs-cluster" {
  name = "example-cluster"
}

resource "aws_ecs_service" "example-ecs-service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 2
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "example-container"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "example-task-definition" {
  family                   = "example-family"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]

  container_definitions = <<DEFINITION
  [
    {
      "name": "example-container",
      "image": "nginx",
      "memory": 256,
      "cpu": 256,
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80
        }
      ]
    }
  ]
  DEFINITION
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-usage-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "75"
  alarm_description   = "This metric checks ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-usage-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "25"
  alarm_description   = "This metric checks ec2 cpu utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs.name
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs.name
}