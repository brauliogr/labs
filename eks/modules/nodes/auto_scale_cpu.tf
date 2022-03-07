resource "aws_autoscaling_policy" "cpu_up" {

    name = format("%-s-nodes-cpu-scale-up", var.cluster_name)

    adjustment_type = "ChangeInCapacity"

    cooldown                 = lookup(var.auto_scale_cpu, "scale_up_cooldown")
    scaling_adjustment       = lookup(var.auto_scale_cpu, "scale_up_add")


   //  Pega a referencia do autoscaling criado pelo EKS e retorna o primeiro item de uma lista pelo nome

    autoscaling_group_name = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
  
}

    // Criando metricas de alarme para escalação de Nodes
    // O alarme vai disparar se o valor for maior ou igual ao Threshold setado na variável.

resource "aws_cloudwatch_metric_alarm" "cpu_up" {

    alarm_name = format("%s-nodes-cpu-high", var.cluster_name)

    comparison_operator = "GreaterThanOrEqualToThreshold"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    statistic = "Average"

    evaluation_periods = lookup(var.auto_scale_cpu, "scale_up_evaluation")
    period             = lookup(var.auto_scale_cpu, "scale_up_period")
    threshold          = lookup(var.auto_scale_cpu, "scale_up_threshold")

    dimensions = {
        AutoScalingGroupName = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
    }

    alarm_actions = [ aws_autoscaling_policy.cpu_up.arn ]

  
}

resource "aws_autoscaling_policy" "cpu_down" {

    name = format("%-s-nodes-cpu-scale-down", var.cluster_name)

    adjustment_type = "ChangeInCapacity"

    cooldown                 = lookup(var.auto_scale_cpu, "scale_down_cooldown")
    scaling_adjustment       = lookup(var.auto_scale_cpu, "scale_down_remove")


   //  Pega a referencia do autoscaling criado pelo EKS e retorna o primeiro item de uma lista pelo nome

    autoscaling_group_name = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
  
}

    // Criando metricas para remoção de nodes
    // O alarme vai disparar se o valor for maior ou igual ao Threshold setado na variável.

resource "aws_cloudwatch_metric_alarm" "cpu_down" {

    alarm_name = format("%s-nodes-cpu-low", var.cluster_name)

    comparison_operator = "LessThanOrEqualToThreshold"
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    statistic = "Average"

    evaluation_periods = lookup(var.auto_scale_cpu, "scale_down_evaluation")
    period             = lookup(var.auto_scale_cpu, "scale_down_period")
    threshold          = lookup(var.auto_scale_cpu, "scale_down_threshold")

    dimensions = {
        AutoScalingGroupName = aws_eks_node_group.cluster.resources[0].autoscaling_groups[0].name
    }

    alarm_actions = [ aws_autoscaling_policy.cpu_down.arn ]

  
}
