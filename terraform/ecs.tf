## cluster設定
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.name}-cluster"
}

resource "aws_ecs_service" "ecs" {
  name                               = "${var.name}-01"
  cluster                            = "${aws_ecs_cluster.ecs_cluster.id}"
  task_definition                    = "knowledge-fagate:1"
  desired_count                      = 2
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets = [
        "${aws_subnet.private-a.id}",
        "${aws_subnet.private-c.id}"
    ]

    security_groups = [
      "${aws_security_group.ecs.id}"
    ]

    assign_public_ip = "false"
  }

  health_check_grace_period_seconds = 0

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    container_name   = "knowledge"
    container_port   = 8080
  }

  scheduling_strategy = "REPLICA"

  deployment_controller {
    type = "CODE_DEPLOY"
  }
  // deployやautoscaleで動的に変化する値を差分だしたくないので無視する
  lifecycle {
    ignore_changes = [
      "desired_count",
      "task_definition",
      "load_balancer",
    ]
  }
  propagate_tags = "TASK_DEFINITION"
}
