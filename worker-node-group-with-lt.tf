resource "aws_eks_node_group" "worker-nodes" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.this.arn
  subnet_ids      = data.aws_subnet_ids.this.ids

  launch_template {
    name         = var.lt_name
    version      = var.lt_version
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    min_size     = var.scaling_min_size
    max_size     = var.scaling_max_size
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "20m"
  }

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]

  tags = merge(
    {
      "Name" = format("%s", var.node_group_name)      
    },
    local.common_tags,
  )
}
