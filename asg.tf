resource "aws_launch_configuration" "asg_launch" {
  image_id        = var.ec2-ami
  instance_type   = var.ec2-instance-type
  key_name        = var.ec2-key-name
  security_groups = [module.security.sg-web.id]

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscale" {
  launch_configuration = aws_launch_configuration.asg_launch.id
  min_size             = var.min-tasks
  max_size             = var.max-tasks
  desired_capacity     = var.min-tasks
  vpc_zone_identifier  = [for i in module.network.public_subnets[*] : i.id]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "test_scale_down"
  autoscaling_group_name = aws_autoscaling_group.autoscale.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "test_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscale.name
  }
}