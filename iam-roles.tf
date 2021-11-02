resource "aws_iam_role" "this" {
  name_prefix = "eksWorkerNodesRole_"
  //path = "/${var.cluster_name}/" //Fail to register node to k8s if path specified
  description = "The role that EKS Worker Nodes will use to interact with AWS resources"
  assume_role_policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY

  tags = merge(
    {
      "Name" = format("%s-iam-role", var.node_group_name)      
    },
    local.common_tags,
  )
}

resource "aws_iam_policy" "Amazon_EBS_CSI_Driver" {
  name_prefix = "Amazon_EBS_CSI_Driver"
  description = "CSI driver for Amazon EBS"

  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ],
        "Resource": "*"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(["AmazonEKSWorkerNodePolicy", "AmazonEKS_CNI_Policy", "AmazonEC2ContainerRegistryReadOnly"])
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "Amazon_EBS_CSI_Driver" {
  policy_arn = aws_iam_policy.Amazon_EBS_CSI_Driver.arn
  role       = aws_iam_role.this.name
}