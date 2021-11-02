data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-vpc"]
  }
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:net:type"
    values = ["k8s-cni"]
  }
}

data "aws_security_groups" "this" {
  tags = {
    Name = "${var.vpc_name}-bastion-sg"
  }
}